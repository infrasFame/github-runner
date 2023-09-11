make:
# default target
	# sudo snap install ngrok 
	cd bin
    curl -sL https://get.bacalhau.org/install.sh | bash
	curl -sSL -O https://raw.githubusercontent.com/bacalhau-project/lilypad-modicum/main/lilypad 	
	chmod +x lilypad
	cd ..


lily:
	curl -sSL -O https://raw.githubusercontent.com/bacalhau-project/lilypad-modicum/main/lilypad 	
	chmod +x lilypad
	./lilypad run sdxl:v0.9-lilypad1 '{"prompt": "an astronaut riding a unicorn", "seed": 9}'
	



 