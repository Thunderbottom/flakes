hades:
	nixos-rebuild switch --flake .#hades

trench:
	nixos-rebuild switch --flake .#trench

up:
	nix flake update

upp:
	nix flake lock --update-input $(f)

history:
	nix profile history --profile /nix/var/nix/profiles/system

gc:
	# remove all generations older than 7 days
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d

	# garbage collect all unused nix store entries
	sudo nix store gc --debug

fmt:
	# format the nix files in the repository
	nix fmt

.PHONY: clean
clean:
	rm -fr result
