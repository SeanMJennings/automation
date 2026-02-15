#!/bin/bash

set -e

sudo apt update
sudo apt upgrade

sudo apt install -y clamav clamav-daemon clamtk
sudo systemctl stop clamav-freshclam
sudo freshclam
sudo systemctl enable clamav-freshclam --now
printf '#!/bin/bash\nnice -n 15 clamscan --bell -i -r /home\n' > ~/clamscan.sh
                                                                                                                                                                                                                                                                           
chmod +x ~/clamscan.sh                                                                                                                               
                                                                                                                                                                                                                                                           
(crontab -l 2>/dev/null; echo "0 15 * * * /home/seanjennings/clamscan.sh") | crontab -                                                                
crontab -l
