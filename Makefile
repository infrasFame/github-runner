# Default target
install:
	sudo snap install ngrok
	make lily 
	make bacalhau 

install-tmux:
	@tmux new-session -d -s install_session \
			"sudo snap install ngrok" \; \
			split-window -v "make lily" \; \
			split-window -h "make bacalhau" \; \
			select-layout even-horizontal \; \
			attach-session -d -t install_session
	

bacalhau:
	curl -sL https://get.bacalhau.org/install.sh | bash
	echo "alias lilyb='bacalhau'" >> .bashrc
	source .bashrc


lily:
	curl -sSL -O https://raw.githubusercontent.com/bacalhau-project/lilypad-modicum/main/lilypad
	chmod +x lilypad
	cp lilypad bin/lily
	./lilypad run sdxl:v0.9-lilypad1 '{"prompt": "an astronaut riding a unicorn", "seed": 9}'

.PHONY: install lily clean bacalhau install


