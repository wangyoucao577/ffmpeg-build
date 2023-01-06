
set FFMPEG_BIN_PATH="ffmpeg-bin"
set TESTS_PATH="./tests/"

%FFMPEG_BIN_PATH%/ffmpeg -y -threads 1 -i %TESTS_PATH%/small_bunny_1080p_60fps.mp4 -c:v libsvtav1 -c:a copy %TESTS_PATH%/out_av1.mp4
%FFMPEG_BIN_PATH%/ffmpeg -y -c:v libdav1d -i %TESTS_PATH%/out_av1.mp4 -f null -
# %FFMPEG_BIN_PATH%/ffmpeg -y -threads 1 -i %TESTS_PATH%/small_bunny_1080p_60fps.mp4 -c:v libaom-av1 -c:a copy %TESTS_PATH%/out.mp4
%FFMPEG_BIN_PATH%/ffmpeg -y -threads 1 -i %TESTS_PATH%/small_bunny_1080p_60fps.mp4 -c:v libx264 -c:a libopus %TESTS_PATH%/out.mp4
# %FFMPEG_BIN_PATH%/ffmpeg -y -i %TESTS_PATH%/out.mp4 -i %TESTS_PATH%/small_bunny_1080p_60fps.mp4 -lavfi "libvmaf=log_fmt=xml:log_path=/dev/stdout:model_path=./build/bin/vmaf_v0.6.1.json" -f null -
%FFMPEG_BIN_PATH%/ffmpeg -y -threads 1 -i %TESTS_PATH%/small_bunny_1080p_60fps.mp4 -c:v libx265 -c:a libfdk_aac %TESTS_PATH%/out_hevc.mp4
%FFMPEG_BIN_PATH%/ffmpeg -y -i %TESTS_PATH%/out_hevc.mp4 -c copy %TESTS_PATH%/out_hevc.flv
%FFMPEG_BIN_PATH%/ffmpeg -y -i %TESTS_PATH%/out_hevc.flv -c copy %TESTS_PATH%/out_hevc2.mp4
%FFMPEG_BIN_PATH%/ffmpeg -y -i %TESTS_PATH%/small_bunny_1080p_60fps.mp4 -vf drawtext="text='hello world':fontfile=%FFMPEG_BIN_PATH%/FreeSans.ttf" -f null -
%FFMPEG_BIN_PATH%/ffmpeg -y -i %TESTS_PATH%/small_bunny_1080p_60fps.mp4 -vf subtitles=%TESTS_PATH%/sintel_en.srt -f null -
%FFMPEG_BIN_PATH%/ffmpeg -y -i %TESTS_PATH%/small_bunny_1080p_60fps.mp4 -vn -af aresample=resampler=soxr -ar 8000 %TESTS_PATH%/out.aac
