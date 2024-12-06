#!/bin/zsh

docker run -it --rm \
  --network host \
  -v /home/syuan/Downloads:/app/Downloads \
  -v /home/syuan/Session:/app/Session \
  telegram_downloader bash
