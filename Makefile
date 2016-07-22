default: install-packages set-shell link-config

install-packages:
	sudo pacman -Sy yaourt
	yaourt -S --needed --noconfirm `cat packages.txt`

set-shell:
	sudo chsh -s /usr/zsh
	
link-config:
