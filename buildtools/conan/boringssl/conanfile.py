import os
from conans import ConanFile, CMake
from conans import tools

class BoringsslConan(ConanFile):
    name = "boringssl"
    version = "0.1.0"
    license = "https://github.com/google/boringssl/blob/master/LICENSE"
    author = "Jay Zhang <wangyoucao577@gmail.com>"
    url = "https://github.com/google/boringssl"
    description = "BoringSSL is a fork of OpenSSL that is designed to meet Google's needs."
    topics = ("boringssl", "openssl", "ssl", "tls", "encryption", "security")
    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False], "fPIC": [True, False]}
    default_options = {"shared": False, "fPIC": True}
    generators = "cmake"
    exports_sources = "../../../third-party/boringssl/*"

    def config_options(self):
        if self.settings.os == "Windows":
            del self.options.fPIC

    def build(self):
        cmakeArgs = []
        if self.settings.os == "Android":
            cmakeArgs.append("-DCMAKE_TOOLCHAIN_FILE={}/build/cmake/android.toolchain.cmake".format(tools.get_env("ANDROID_NDK_ROOT")))
        elif self.settings.os == "iOS":
            cmakeArgs.append("-DCMAKE_OSX_SYSROOT={}".format(self.settings.os.sdk))
            cmakeArgs.append("-DCMAKE_OSX_ARCHITECTURES={}".format(tools.to_apple_arch(self.settings.arch)))

        cmake = CMake(self, generator="Ninja")
        cmake.verbose = True
        cmake.configure(args=cmakeArgs)
        cmake.build()
        cmake.install()

    def package_info(self):
        self.cpp_info.libs = ["boringssl"]
