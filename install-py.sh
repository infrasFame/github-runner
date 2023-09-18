tmux new-session -d -s poetry_install

# Send commands to the tmux session
tmux send-keys -t poetry_install 'pip install poetry' C-m
tmux send-keys -t poetry_install 'exit' C-m

# Attach to the tmux session to observe the installation process
tmux attach -t poetry_install