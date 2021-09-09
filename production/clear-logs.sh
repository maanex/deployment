echo ":: Delete Docker unused containers"
truncate -s 0 /var/lib/docker/containers/*/*-json.log

echo ":: Delete Docker log files"
find /var/lib/docker/containers/ -type f -name "*.log" -delete

echo ":: Delete Docker unused images"
docker system prune -a -f

echo ":: Delete Nginx log files"
rm -f /var/log/nginx/*
