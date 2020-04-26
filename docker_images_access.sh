output=$(docker-compose images | grep "trinhnx" |  awk '{print $4}')
docker run -it $output /bin/bash

