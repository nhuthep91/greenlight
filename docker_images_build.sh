cd ~/greenlight
git pull
docker-compose down
./scripts/image_build.sh trinhnx v2
docker-compose up -d
