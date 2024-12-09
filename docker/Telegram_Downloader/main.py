from pyrogram import Client
import re
import os
from tqdm import tqdm

# Telegram API credentials
api_id = 28691258
api_hash = "222fa80556faa119f5a565590039cbff"

# Save path and URL file
save_path = "/home/syuan/Downloads"
url_file = "wait_to_download.txt"
os.makedirs(save_path, exist_ok=True)

def parse_url(url):
    """Parse Telegram URL to extract chat_id and message_id."""
    match = re.match(r"https://t\.me/c/(\d+)/(\d+)", url)
    if not match:
        raise ValueError(f"Invalid URL: {url}")
    chat_id = int("-100" + match.group(1))
    message_id = int(match.group(2))
    return chat_id, message_id


def download_file(client, chat_id, message_id):
    """Download a file from Telegram."""
    try:
        print(f"[INFO] 正在获取消息 chat_id={chat_id}, message_id={message_id}")
        message = client.get_messages(chat_id, message_id)

        # Check if the message contains a video or document
        if not (message and (message.document or message.video)):
            raise ValueError(f"在 message_id={message_id} 中未找到文档或视频")

        # Determine the file type and name
        media = message.document or message.video
        filename = media.file_name if media.file_name else f"telegram_file_{message_id}"
        filepath = os.path.join(save_path, filename)

        # Check if file already exists
        if os.path.exists(filepath):
            print(f"[INFO] 文件已存在，跳过下载: {filename}")
            return

        file_size = media.file_size
        print(f"[INFO] 正在下载: {filename} ({file_size / (1024**2):.2f} MB)")

        with tqdm(total=file_size, unit="B", unit_scale=True, desc=filename, dynamic_ncols=True) as bar:
            def progress(current, total):
                bar.update(current - bar.n)

            client.download_media(message, file_name=filepath, progress=progress)

        print(f"[SUCCESS] 下载完成: {filename}")

    except Exception as e:
        print(f"[ERROR] 无法下载 message_id={message_id}: {str(e)}")


def main():
    """Read URLs from file and process each one sequentially."""
    try:
        # Read URLs from file
        with open(url_file, "r") as file:
            urls = [line.strip() for line in file if line.strip()]
        print(f"[INFO] 找到 {len(urls)} 个需要处理的 URL")

        if not urls:
            print("[INFO] 没有需要处理的 URL，退出")
            return

        # Initialize Telegram client
        with Client("tg_downloader_session", api_id, api_hash) as app:
            for url in urls:
                try:
                    chat_id, message_id = parse_url(url)
                    download_file(app, chat_id, message_id)
                except ValueError as ve:
                    print(f"[ERROR] 跳过 URL: {url}。原因: {ve}")
                except Exception as e:
                    print(f"[ERROR] URL 出现意外错误: {url}。原因: {e}")

    except KeyboardInterrupt:
        print("\n[INFO] 用户中断了进程，安全退出...")
    except Exception as e:
        print(f"[ERROR] 脚本执行失败: {e}")


if __name__ == "__main__":
    main()
