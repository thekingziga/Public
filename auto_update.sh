#!/bin/bash

# Read email credentials from configuration file
source /home/word/email_credentials.conf

# Function to check if a reboot is required
check_reboot() {
    if [ -f /var/run/reboot-required ]; then
        echo "<span style=\"color: red;\">System requires a reboot.</span>"
    else
        echo "<span style=\"color: green;\">No reboot is required.</span>"
    fi
}

# Function to get the hostname
get_hostname() {
    hostname
}

# Function to get the current timestamp in Europe/Ljubljana timezone
get_timestamp() {
    TZ="Europe/Ljubljana" date "+%F %T"
}

# Function to perform system update and capture output
perform_system_update() {
    sudo apt update
    sudo apt upgrade -y
    sudo apt autoremove -y
}

# Capture start time
start_time=$(date +%s)

# Perform system update
update_output=$(perform_system_update 2>&1)

# Capture end time
end_time=$(date +%s)

# Calculate update duration
duration=$((end_time - start_time))

# Check if a reboot is required
reboot_status=$(check_reboot)

# Get hostname
hostname=$(get_hostname)

# Get timestamp
timestamp=$(get_timestamp)

# Build email content with HTML formatting and styling
email_content="<html>
<head>
<style>
  body {
    font-family: Arial, sans-serif;
    background-color: #f5f5f5;
    color: #333;
  }
  h2 {
    color: #333;
    border-bottom: 2px solid #333;
    padding-bottom: 5px;
  }
  table {
    border-collapse: collapse;
    width: 100%;
    margin-top: 15px;
  }
  th, td {
    border: 1px solid #ddd;
    padding: 8px;
    text-align: left;
  }
  th {
    background-color: #f2f2f2;
  }
  .reboot {
    font-weight: bold;
    color: red;
  }
  .reboot-yes {
    color: red;
  }
  .reboot-no {
    color: green;
  }
</style>
</head>
<body>
<h2>Auto Update Summary</h2>
<p><strong>Hostname:</strong> $hostname</p>
<p><strong>Timestamp (Europe/Ljubljana):</strong> $timestamp</p>
<h3>Update Summary</h3>
<pre>$update_output</pre>
<h3>Reboot Status</h3>
<p class=\"reboot\">$reboot_status</p>
</body>
</html>"

# Subject line with timestamp
subject="Auto Update Summary - $hostname - $timestamp - Reboot: $(check_reboot | sed 's/<[^>]*>//g')"

# Send email summary using msmtp with content-type set to text/html
echo -e "From: $EMAIL_FROM\nTo: $EMAIL_TO\nSubject: $subject\nContent-Type: text/html\n\n$email_content" | msmtp -C /root/.msmtprc --from="$EMAIL_FROM" --read-recipients -t
