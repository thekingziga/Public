sudo nano /etc/systemd/system/auto-update.service

[Unit]
Description=Auto Update Service
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=/bin/bash /path/to/your/script.sh

[Install]
WantedBy=multi-user.target

sudo systemctl enable auto-update.service
sudo systemctl start auto-update.service

sudo systemctl disable auto-update.service

-----------------------------------------------------------
sudo nano /etc/systemd/system/auto-update.timer

[Unit]
Description=Run Auto Update Service every 3 days

[Timer]
OnBootSec=0
OnCalendar=*-*-* 0/3:00:00
Persistent=true
Unit=auto-update.service

[Install]
WantedBy=timers.target

sudo systemctl enable auto-update.timer
sudo systemctl start auto-update.timer


sudo chmod 600 email_credentials.conf    sudo chown root:root /root/.msmtprc        sudo chmod +x auto_update.sh

sudo apt install msmtp
