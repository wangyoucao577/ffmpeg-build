# ffmpeg-build
Build scripts and artifacts for ffmpeg. 

## Version
Branch for Nvidia CUDA NVENC/NVDEC hardware acceleration.     
Including versions:     
- `ffmpeg n4.3.3`    
- `nv-codec-headers n11.0.10.1`    

## Prerequisites    
- A ​supported GPU
- Supported drivers for your operating system
​- The [NVIDIA Codec SDK](https://docs.nvidia.com/cuda/cuda-quick-start-guide/index.html) 

## Build on Linux   

```bash
# ffnvcodec
$ git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
$ cd nv-codec-headers && sudo make install && cd –

# ffmpeg
#   `--nvccflags="-gencode arch=compute_75,code=sm_75 -O2"` is required for ffmpeg version before n5.0, 
#   otherwise `ERROR: failed checking for nvcc.` will occur.
$ ./configure --prefix=$(pwd)/build --enable-nonfree --enable-gpl --enable-static --disable-shared --enable-cuda-nvcc --enable-nvenc --enable-nvdec --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --nvccflags="-gencode arch=compute_75,code=sm_75 -O2"
$ make -j && make install
```

## Known Issues
### No decoder surfaces left
See details below.     
In the testing. I found that it works well on `ffmpeg n4.3.3`, but failed since `ffmpeg n4.4`, looks like something changed between the two versions, which **NEED to investigate** more.     
```bash
$ ffmpeg -y -hwaccel cuda -hwaccel_output_format cuda -i bbb_sunflower_1080p_60fps_normal.mp4 -c:a copy -c:v h264_nvenc -b:v 5M output.mp4
ffmpeg version n4.4 Copyright (c) 2000-2021 the FFmpeg developers
  built with gcc 9 (Ubuntu 9.4.0-1ubuntu1~20.04.1)
  configuration: --prefix=/root/workspace/ffmpeg-build/ffmpeg/../build --enable-nonfree --enable-gpl --enable-static --disable-shared --enable-cuda-nvcc --enable-nvenc --enable-nvdec --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --nvccflags='-gencode arch=compute_75,code=sm_75 -O2'
  libavutil      56. 70.100 / 56. 70.100
  libavcodec     58.134.100 / 58.134.100
  libavformat    58. 76.100 / 58. 76.100
  libavdevice    58. 13.100 / 58. 13.100
  libavfilter     7.110.100 /  7.110.100
  libswscale      5.  9.100 /  5.  9.100
  libswresample   3.  9.100 /  3.  9.100
  libpostproc    55.  9.100 / 55.  9.100
Input #0, mov,mp4,m4a,3gp,3g2,mj2, from 'bbb_sunflower_1080p_60fps_normal.mp4':
  Metadata:
    major_brand     : isom
    minor_version   : 1
    compatible_brands: isomavc1
    creation_time   : 2013-12-16T17:59:32.000000Z
    title           : Big Buck Bunny, Sunflower version
    artist          : Blender Foundation 2008, Janus Bager Kristensen 2013
    comment         : Creative Commons Attribution 3.0 - http://bbb3d.renderfarming.net
    genre           : Animation
    composer        : Sacha Goedegebure
  Duration: 00:10:34.53, start: 0.000000, bitrate: 4486 kb/s
  Stream #0:0(und): Video: h264 (High) (avc1 / 0x31637661), yuv420p, 1920x1080 [SAR 1:1 DAR 16:9], 4001 kb/s, 60 fps, 60 tbr, 60k tbn, 120 tbc (default)
    Metadata:
      creation_time   : 2013-12-16T17:59:32.000000Z
      handler_name    : GPAC ISO Video Handler
      vendor_id       : [0][0][0][0]
  Stream #0:1(und): Audio: mp3 (mp4a / 0x6134706D), 48000 Hz, stereo, fltp, 160 kb/s (default)
    Metadata:
      creation_time   : 2013-12-16T17:59:37.000000Z
      handler_name    : GPAC ISO Audio Handler
      vendor_id       : [0][0][0][0]
  Stream #0:2(und): Audio: ac3 (ac-3 / 0x332D6361), 48000 Hz, 5.1(side), fltp, 320 kb/s (default)
    Metadata:
      creation_time   : 2013-12-16T17:59:37.000000Z
      handler_name    : GPAC ISO Audio Handler
      vendor_id       : [0][0][0][0]
    Side data:
      audio service type: main
Stream mapping:
  Stream #0:0 -> #0:0 (h264 (native) -> h264 (h264_nvenc))
  Stream #0:2 -> #0:1 (copy)
Press [q] to stop, [?] for help
[mp4 @ 0x562b0b2d3680] track 1: codec frame size is not set
Output #0, mp4, to 'output.mp4':
  Metadata:
    major_brand     : isom
    minor_version   : 1
    compatible_brands: isomavc1
    composer        : Sacha Goedegebure
    title           : Big Buck Bunny, Sunflower version
    artist          : Blender Foundation 2008, Janus Bager Kristensen 2013
    comment         : Creative Commons Attribution 3.0 - http://bbb3d.renderfarming.net
    genre           : Animation
    encoder         : Lavf58.76.100
  Stream #0:0(und): Video: h264 (Main) (avc1 / 0x31637661), cuda(progressive), 1920x1080 [SAR 1:1 DAR 16:9], q=2-31, 5000 kb/s, 60 fps, 15360 tbn (default)
    Metadata:
      creation_time   : 2013-12-16T17:59:32.000000Z
      handler_name    : GPAC ISO Video Handler
      vendor_id       : [0][0][0][0]
      encoder         : Lavc58.134.100 h264_nvenc
    Side data:
      cpb: bitrate max/min/avg: 0/0/5000000 buffer size: 10000000 vbv_delay: N/A
  Stream #0:1(und): Audio: ac3 (ac-3 / 0x332D6361), 48000 Hz, 5.1(side), fltp, 320 kb/s (default)
    Metadata:
      creation_time   : 2013-12-16T17:59:37.000000Z
      handler_name    : GPAC ISO Audio Handler
      vendor_id       : [0][0][0][0]
    Side data:
      audio service type: main
[h264 @ 0x562b0bd7e0c0] No decoder surfaces left0:00:00.00 bitrate=N/A dup=2 drop=0 speed=   0x
[h264 @ 0x562b0bd9aec0] No decoder surfaces left
[h264 @ 0x562b0bdb7cc0] No decoder surfaces left
[h264 @ 0x562b0bdd4ac0] No decoder surfaces left
[h264 @ 0x562b0bd612c0] No decoder surfaces left
Error while decoding stream #0:0: Invalid data found when processing input
    Last message repeated 1 times
[h264 @ 0x562b0bd7e0c0] No decoder surfaces left
Error while decoding stream #0:0: Invalid data found when processing input
[h264 @ 0x562b0bd9aec0] No decoder surfaces left
Error while decoding stream #0:0: Invalid data found when processing input
Impossible to convert between the formats supported by the filter 'Parsed_null_0' and the filter 'auto_scaler_0'
Error reinitializing filters!
Failed to inject frame into filter network: Function not implemented
Error while processing the decoded data for stream #0:0
Conversion failed!
```


## References
- https://trac.ffmpeg.org/wiki/HWAccelIntro
- https://docs.nvidia.com/video-technologies/video-codec-sdk/ffmpeg-with-nvidia-gpu/index.html#compiling-ffmpeg
- https://developer.nvidia.com/blog/nvidia-ffmpeg-transcoding-guide/
- https://docs.nvidia.com/cuda/cuda-quick-start-guide/index.html

