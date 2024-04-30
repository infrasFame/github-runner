# Default target
install: 
	ln ~/.bashrc .bashrc
	make libp2p &
	make install-ipfs &
	sudo snap install ngrok &
	make setup-repos
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

setup-repos:
	gh repo clone DeCenter-AI/compute.decenter-ai decenter
	


.PHONY: install lily clean bacalhau install

install-ipfs:
	cd /tmp
	wget https://dist.ipfs.tech/kubo/v0.27.0/kubo_v0.27.0_linux-amd64.tar.gz
	tar -xvzf kubo_v0.27.0_linux-amd64.tar.gz
	cd kubo
	sudo bash install.sh
	ipfs --version

GOBIN ?= "/usr/local/bin"

libp2p:
	@echo "configuring libp2p"
	GOBIN=${GOBIN} go install github.com/studiokaiji/libp2p-port-forward@latest
	ln -s ${GOBIN}/libp2p-port-forward ${GOBIN}/p2p
	ln -s ${GOBIN}/libp2p-port-forward ${GOBIN}/libp2p
