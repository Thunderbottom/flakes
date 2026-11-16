"""Keep externals above the laptop and maximize refresh at each active resolution."""

import json
import os
import socket
import sys
import time


def request(message):
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
        client.settimeout(5)
        client.connect(os.environ["NIRI_SOCKET"])
        client.sendall(json.dumps(message).encode() + b"\n")
        with client.makefile("r") as stream:
            reply = json.loads(stream.readline())
        if "Err" in reply:
            raise RuntimeError(reply["Err"])
        return reply["Ok"]


def positions(outputs):
    active = {name: output["logical"] for name, output in outputs.items()
              if output.get("logical") is not None}
    internal = next((name for name in sorted(active)
                     if name.lower().startswith(("edp-", "lvds-", "dsi-"))), None)
    # Do not rearrange a desktop-only setup, or outputs while the lid is closed.
    if internal is None:
        return {}

    external = sorted(name for name in active if name != internal)
    result = {internal: (0, 0)}
    # Multiple externals form a bottom-aligned row centered above the laptop.
    width = sum(active[name]["width"] for name in external)
    x = (active[internal]["width"] - width) // 2
    for name in external:
        result[name] = (x, -active[name]["height"])
        x += active[name]["width"]
    return result


def fastest_mode(output):
    # Leave disabled outputs and user-defined custom modes alone.
    index = output.get("current_mode")
    if output.get("logical") is None or index is None or output.get("is_custom_mode"):
        return None
    current = output["modes"][index]
    best = max(
        (mode for mode in output["modes"]
         if (mode["width"], mode["height"]) == (current["width"], current["height"])),
        key=lambda mode: mode["refresh_rate"],
    )
    return best if best["refresh_rate"] > current["refresh_rate"] else None


def arrange():
    outputs = request("Outputs")["Outputs"]
    changed_mode = False
    for name, output in outputs.items():
        mode = fastest_mode(output)
        if mode is None:
            continue
        request({"Output": {
            "output": name,
            "action": {"Mode": {"mode": {"Specific": {
                "width": mode["width"],
                "height": mode["height"],
                # Output modes report millihertz; ConfiguredMode accepts hertz.
                "refresh": mode["refresh_rate"] / 1000,
            }}}},
        }})
        changed_mode = True
    if changed_mode:
        # A modeset may change automatic scaling and hence logical geometry.
        outputs = request("Outputs")["Outputs"]
    for name, (x, y) in positions(outputs).items():
        logical = outputs[name]["logical"]
        if (logical["x"], logical["y"]) == (x, y):
            continue
        request({"Output": {
            "output": name,
            "action": {"Position": {"position": {"Specific": {"x": x, "y": y}}}},
        }})


def main():
    once = "--once" in sys.argv[1:]
    while True:
        try:
            arrange()
        except (FileNotFoundError, ConnectionRefusedError, BrokenPipeError):
            # The compositor has exited; do not leave a background process behind.
            return
        except (OSError, RuntimeError) as error:
            if once:
                raise
            print(f"niri output layout: {error}", file=sys.stderr, flush=True)
        if once:
            return
        # Niri has no output-change IPC event. Check for hotplug, scale, rotation
        # and config changes, but only send mode/position requests when necessary.
        time.sleep(2)


if __name__ == "__main__":
    main()
