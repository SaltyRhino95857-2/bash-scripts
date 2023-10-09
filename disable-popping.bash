#! /bin/bash


if [ $(cat /sys/module/snd_hda_intel/parameters/power_save) == 1 ]
	then
		read -p 'Your system has not been fixed! do you want to fix it? [Y/N]' start
		if [ $start^^ == Y ]
			then
				echo "0" | sudo tee /sys/module/snd_hda_intel/parameters/power_save
				if [ $(cat /sys/module/snd_hda_intel/parameters/power_save) == 0 ]
					then
						read -p 'Did it work? [Y/N]' work
						if [ $work^^ == Y ]
							then
								echo "options snd_hda_intel power_save=0" | sudo tee -a /etc/modprobe.d/audio_disable_powersave.conf
								echo Done.
								exit
							else
								exit
							fi
					else
						echo An error occured, try again in root.
					fi
			else
				exit
	else
		echo Your system has been fixed. Exiting.
		exit


# END
