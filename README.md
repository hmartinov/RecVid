# RecVid (Lubuntu Edition)

Record your screen **with system audio** and save smooth, synchronized `.mp4` videos using a simple graphical interface.  
Designed for **Linux (Lubuntu/XFCE)** environments and optimized for low-end machines and office workflows.

## Features

- Records full screen + internal audio in real time
- Works smoothly even on weak hardware (dual-process: video + audio)
- Audio and video are automatically merged into one `.mp4` file
- Uses **graphical dialogs** via `zenity`
- No terminal input required — user-friendly experience
- Automatically checks for new version and updates from GitHub
- Safe fallback if dependencies are missing
- Files are saved in `~/Videos/` with timestamps
- Simple final dialog: "Open folder" or "Play video"
- Automatically downloads the app icon if missing and places it in the correct folder (`~/.local/share/icons/`).

## Requirements

Ensure the following packages are installed:

```bash
sudo apt install ffmpeg zenity xdg-utils xdpyinfo pulseaudio curl
```

## Installation

1. **Download or clone the repository:**

```bash
git clone https://github.com/hmartinov/RecVid.git
cd RecVid
```

2. **Make the installation script executable and run it:**

```bash
chmod +x install_recvid.sh
./install_recvid.sh
```

The script will:
- Automatically install required tools (`ffmpeg`, `zenity`, `xdg-open`, `pulseaudio`, `curl`)
- Copy the main script to `~/bin/`
- Register a `.desktop` launcher so RecVid appears in your system menu

## Output

- A single `.mp4` video is saved in `~/Videos/`, named like:
  ```
  recvid-20250703-132215.mp4
  ```

- Temporary audio/video files are automatically cleaned up

## Example usage

Launch the program from your system menu (or create a shortcut), or run manually:

```bash
~/bin/recvid.sh
```

Once recording starts:
- Close the info window to stop recording
- Wait for merging process to finish (automatic)
- Choose to open folder or play the final video

## Ideal for

- Recording YouTube, presentations, or tutorials
- Weak laptops or thin clients running Lubuntu/XFCE
- Schools, offices, and educational environments
- GUI-focused users who dislike terminal tools

## Download

Get the latest version from the [release](https://github.com/hmartinov/RecVid/releases) folder.

## Changelog

See full release history in the [CHANGELOG.md](./CHANGELOG.md) file.

## License

MIT License – free for personal and commercial use.

## Author

H. Martinov  
[hmartinov@dmail.ai](mailto:hmartinov@dmail.ai)  
[GitHub](https://github.com/hmartinov/RecVid)

---

_See instructions and update info directly in the app menu._# RecVid
