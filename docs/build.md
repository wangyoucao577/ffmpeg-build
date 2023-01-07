# Build
Build [ffmpeg](../ffmpeg/) with its [dependencies](../third-party/) from source, optionally with debugging support.     

## Prerequisites

- `gcc`(or `clang` on macosx)
- [automake/autotools](https://www.gnu.org/software/automake/)
- [cmake](https://cmake.org/)
- [ninja](https://ninja-build.org/)
- [meson](https://mesonbuild.com/)
- [yasm](https://yasm.tortall.net/)
- [nasm](https://www.nasm.us/)
- [conan](https://conan.io/), optionally for `ios/android`
- [Bear](https://github.com/rizsotto/Bear), optionally for debugging via [vscode](https://code.visualstudio.com/)/[clangd](https://clangd.llvm.org/)

## Linux
Refer to [linux-debian10.dockerfile](../buildtools/docker/linux-debian10.dockerfile)/[linux-debian11.dockerfile](../buildtools/docker/linux-debian11.dockerfile) to install prerequisites.      

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

## ENV Options

`export XXX=YYY` before run `./buildtools/scripts/build.sh` to leverage following env options.          


| name | available values | default value | comments |
| - | - | - | - |
| `FFMPEG_BUILD_TYPE` | `Release`, `Debug` | `Release` | build type for ffmpeg | 
| `FFMPEG_ENABLE_FATE_TESTS` | `true`, `false` | `false` | whether enable ffmpeg fate tests |
| `FFMPEG_TOOLCHAIN_COVERAGE` | `true`, `false` | `false` | configure `ffmpeg` with `--toolchain=gcov`, see more in [9.2 Visualizing Test Coverage](https://ffmpeg.org/developer.html#Visualizing-Test-Coverage). |
| `FFMPEG_TOOLCHAIN_VALGRIND_MEMCHECK` | `true`, `false` | `false` | configure `ffmpeg` with `--toolchain=valgrind-memcheck`, see more in [9.3 Using Valgrind](https://ffmpeg.org/developer.html#Using-Valgrind). |

## References
- [CompilationGuide](https://trac.ffmpeg.org/wiki/CompilationGuide)
- [Platform Specific Information](https://www.ffmpeg.org/platform.html)

