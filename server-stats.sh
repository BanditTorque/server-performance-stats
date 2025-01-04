#!/bin/bash

echo "------------------------------------"
echo "          Server Stats"
echo "------------------------------------"

# Total CPU Usage
echo "Total CPU Usage:"
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk -F ',' '{print 100 - $4}' | xargs printf "%.2f%%")
echo "  $CPU_USAGE"

# Total Memory Usage
echo "Total Memory Usage:"
free -m | awk '/Mem:/ {printf "  Used: %d MB (%.2f%%), Free: %d MB (%.2f%%)\n", $3, $3/$2*100, $4, $4/$2*100}'

# Total Disk Usage
echo "Total Disk Usage:"
df -h / | awk 'NR==2 {printf "  Used: %s of %s (%s)\n", $3, $2, $5}'

# Top 5 Processes by CPU Usage
echo "Top 5 Processes by CPU Usage:"
ps -eo %cpu,pid,user,args --sort=-%cpu | head -n6 | awk 'NR==1{printf "%-8s %-8s %-10s %s\n", "CPU%", "PID", "USER", "COMMAND"} NR>1{printf "%-8.2f %-8s %-10s %s\n", $1, $2, $3, $4}'

# Top 5 Processes by Memory Usage
echo "Top 5 Processes by Memory Usage:"
ps -eo %mem,pid,user,args --sort=-%mem | head -n6 | awk 'NR==1{printf "%-8s %-8s %-10s %s\n", "MEM%", "PID", "USER", "COMMAND"} NR>1{printf "%-8.2f %-8s %-10s %s\n", $1, $2, $3, $4}'

# Additional System Information (Stretch Goal)
echo "------------------------------------"
echo "         Additional Stats"
echo "------------------------------------"

# OS Version
echo "OS Version:"
grep PRETTY_NAME /etc/os-release | cut -d'"' -f2

# Uptime and Load Average
echo "Uptime and Load Average:"
uptime | awk -F'[, ]+' '{printf "  Uptime: %s days, Load Average: %s %s %s\n", $3, $(NF-2), $(NF-1), $NF}'

# Logged-In Users
echo "Logged In Users:"
who | awk '{print "  User: " $1 ", Logged in at: " $4 " " $5}'

# Failed Login Attempts
echo "Failed Login Attempts:"
grep "Failed password" /var/log/auth.log 2>/dev/null | wc -l || echo "  Log not accessible"
