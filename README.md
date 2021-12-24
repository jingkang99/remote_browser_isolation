# Remote Browser Isolation using VNC

The image is fine-tuned with CPU/memory/disk usage in mind, ideal for safe browsering and hide privacy.

![image](https://user-images.githubusercontent.com/10793075/147338350-26b32565-60b7-47d0-b318-ad6b61a353d7.png)

## Run

- docker run -d -p 5909:6900 -p 6909:6901 --name mk-remote-browser-1 jingkang/chromium:95

## Issues
- No sound
- No support for Chinese copy/paste - vnc protocol issue
