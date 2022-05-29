# Build
Build ffmpeg with its dependencies from source, with debugging support.     

## Prerequisites

- `gcc`(or `clang` on macosx)
- [automake/autotools](https://www.gnu.org/software/automake/)
- [cmake](https://cmake.org/)
- [ninja](https://ninja-build.org/)
- [meson](https://mesonbuild.com/)
- [yasm](https://yasm.tortall.net/)
- [nasm](https://www.nasm.us/)
- [openssl](https://www.openssl.org/)
- [Bear](https://github.com/rizsotto/Bear) for debugging via [vscode](https://code.visualstudio.com/)/[clangd](https://clangd.llvm.org/)

## Linux
Refer to [linux-debian10.dockerfile](../buildtools/docker/linux-debian10.dockerfile) to install prerequisites.      

```bash
# (optional) enable debug
export FFMPEG_BUILD_TYPE=Debug

# build 
./buildtools/scripts/build.sh
```

## Mac
Refer to [build-mac.yml](../.github/workflows/build-mac.yml) to install prerequisites.      

```bash
# (optional) enable debug
export FFMPEG_BUILD_TYPE=Debug

# build 
./buildtools/scripts/build.sh
```

## Windows

### MSYS2(MINGW64/UCRT64)
Refer to [build-win.yml](../.github/workflows/build-win.yml) to install prerequisites.      

```bash
# (optional) enable debug
export FFMPEG_BUILD_TYPE=Debug

# build 
./buildtools/scripts/build.sh
```

## References
- [CompilationGuide](https://trac.ffmpeg.org/wiki/CompilationGuide)