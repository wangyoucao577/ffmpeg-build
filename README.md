# ffmpeg-build    
[![Build - linux](https://github.com/wangyoucao577/ffmpeg-build/actions/workflows/build-linux.yml/badge.svg)](https://github.com/wangyoucao577/ffmpeg-build/actions/workflows/build-linux.yml) [![Build - win](https://github.com/wangyoucao577/ffmpeg-build/actions/workflows/build-win.yml/badge.svg)](https://github.com/wangyoucao577/ffmpeg-build/actions/workflows/build-win.yml) [![Build - mac](https://github.com/wangyoucao577/ffmpeg-build/actions/workflows/build-mac.yml/badge.svg)](https://github.com/wangyoucao577/ffmpeg-build/actions/workflows/build-mac.yml) [![Build - ios](https://github.com/wangyoucao577/ffmpeg-build/actions/workflows/build-ios.yml/badge.svg)](https://github.com/wangyoucao577/ffmpeg-build/actions/workflows/build-ios.yml) [![Build - android](https://github.com/wangyoucao577/ffmpeg-build/actions/workflows/build-android.yml/badge.svg)](https://github.com/wangyoucao577/ffmpeg-build/actions/workflows/build-android.yml) [![Build - docker](https://github.com/wangyoucao577/ffmpeg-build/actions/workflows/build-docker.yml/badge.svg)](https://github.com/wangyoucao577/ffmpeg-build/actions/workflows/build-docker.yml)       

Build [ffmpeg](./ffmpeg) with its [dependencies](./third-party/) from source, which may achieve several purposes:      
- Generate popular **cross-platform executable binaries** for generic usage, such as `ffmpeg, ffplay, ffprobe, srt-*, rtmpdump`, etc;    
- Generate popular **cross-platform libraries** for developping upon them, mostly `libav*`;      
- One-click to launch [ffmpeg](./ffmpeg) debugging via `vscode`+`gdb/lldb`, which is essential for understanding details;    



```bash
git submodule update --init       
```

## Docs
- [Build](./docs/build.md)      
- [FFmpeg with Nvidia GPU](./docs/ffmpeg-with-nvidia-gpu.md)

