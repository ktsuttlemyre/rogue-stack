    user_data = <<- EOF1
	#!/bin/bash -xe

	#update and install tools
	apt update
	snap install nano --classic
	CMD="java"
	if ! command -v "$CMD" &> /dev/null
	then
	apt install default-jdk --yes
	fi
	CMD="git"
	if ! command -v "$CMD" &> /dev/null
	then
	apt install "$CMD" --yes
	fi

	sudo -i -u ubuntu bash <<- EOF2
		FILE="./.ssh/config"
		#Config git
		if [ ! -f "$FILE" ]
		then
			touch "$FILE"
			chmod 600 "$FILE"
			printf "Host github-shipcraft \n    HostName github.com \n    StrictHostKeyChecking no \n    AddKeysToAgent yes \n    PreferredAuthentications publickey \n    IdentityFile ~/.ssh/authorized_keys " >> "$FILE"
		fi

		FILE="ShipCraft"
		#Check out code
		if [ ! -f "$FILE" ]
		then
			git clone git@github-shipcraft:ktsuttlemyre/ShipCraft.git
			cd "$FILE"
		else
			cd "$FILE"
			git pull
		fi

		#Run
		./spigotupdater.sh
		EOF2
	EOF1