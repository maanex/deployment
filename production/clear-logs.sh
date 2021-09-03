echo ":: Delete unused containers"
truncate -s 0 /var/lib/docker/containers/*/*-json.log

echo ":: Delete log files"
find /var/lib/docker/containers/ -type f -name "*.log" -delete

echo ":: Delete unused images"
docker system prune -a -f
