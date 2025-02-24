# start.sh
#!/bin/sh
# Start nginx in the background
nginx -g 'daemon off;' &
exec npm start