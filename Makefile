# Default target
install: 
	ln ~/.bashrc .bashrc
	make libp2p &
	make install-ipfs &
	sudo snap install ngrok &
	make setup-repos
	make install-lily-v2
	make bacalhau 
	npm install -g just-install
	# source .bashrc #FIXME: error
	curl -sSf https://raw.githubusercontent.com/CoopHive/hive/main/install.sh | sh -s -- all

install-go:
	go install github.com/owenthereal/goup/cmd/goup@latest

	goup version

	goup ls

	go install github.com/cosmtrek/air@latest
	go install github.com/clipperhouse/gen@latest
	go install golang.org/dl/gotip@latest

	curl https://wazero.io/install.sh | sh
	cp ./bin/wazero $GOBIN/wasm
	cp ./bin/wazero $GOBIN/wazero
	curl https://wasmtime.dev/install.sh -sSf | bash
	

	# echo 'export PATH="$PATH:~/.go/bin"' >> ~/.bashrc
	# echo 'export PATH="$PATH:~/.go/current/bin"' >> ~/.bashrc
	# echo 'unset GOROOT' >> ~/.bashrc

	source ~/.bashrc

install-tmux:
	@tmux new-session -d -s install_session \
			"sudo snap install ngrok" \; \
			split-window -v "make lily" \; \
			split-window -h "make bacalhau" \; \
			select-layout even-horizontal \; \
			attach-session -d -t install_session

bacalhau:
	curl -sL https://get.bacalhau.org/install.sh | bash
	 ln -s /usr/local/bin/bacalhau /usr/local/bin/b
	@WHEREIS_RESULT=$$(whereis bacalhau | cut -d ' ' -f 2); \
	if [ -n "$$WHEREIS_RESULT" ]; then \
		cp "$$WHEREIS_RESULT" ./bin/; \
		cp "$$WHEREIS_RESULT" ./bin/lilyb; \
		cp "$$WHEREIS_RESULT" ~/go/bin/lilyb; \
		cp "$$WHEREIS_RESULT" ~/go/bin/; \
		echo "bacalhau copied to ./bin/"; \
	else \
		echo "bacalhau not found."; \
	fi


install-lily-v2:
	# curl -sSL -O https://github.com/bacalhau-project/lilypad/releases/download/v2.0.0-b7e9e04/lilypad
	# FIXME: save as lilypad2
	# chmod +x lilypad
	# cp lilypad bin/lily2
	# cp lilypad ~/go/bin/lilypad2
	# cp lilypad ~/go/bin/lily2
	go install github.com/bacalhau-project/lilypad@latest
	cp ~/go/bin/lilypad  ~/go/bin/lily


setup-repos:
	gh repo clone DeCenter-AI/compute.decenter-ai decenter &
	gh repo clone CoopHive/hive &
	# git clone git@github.com:learnery-engine/api.creator.learnery.git learnery 
	# gh repo clone Nasfame/lilypad-modicum modicum 
	#gh repo clone bacalhau-project/lilypad
	git clone --recursive git@github.com:antFame/ant

.PHONY: install lily clean bacalhau install

install-ipfs:
	cd /tmp
	wget https://dist.ipfs.tech/kubo/v0.27.0/kubo_v0.27.0_linux-amd64.tar.gz
	tar -xvzf kubo_v0.27.0_linux-amd64.tar.gz
	cd kubo
	sudo bash install.sh
	ipfs --version

libp2p:
	echo "configuring libp2p"
	export GOBIN=/usr/local/bin
	go install github.com/studiokaiji/libp2p-port-forward@latest
	cd $GOBIN
	ln -s libp2p-port-forward p2p
	ln -s libp2p-port-forward libp2p
