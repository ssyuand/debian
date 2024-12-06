#!/bin/zsh

# Run the Docker container for Telegram Downloader
docker run -it --rm \
  --name my-python-app \
  --network host \
  -v /home/syuan/Downloads:/app/Downloads \
  -v /home/syuan/Session:/app/Session \
  telegram_downloader
