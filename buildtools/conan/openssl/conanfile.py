import os
from conans import ConanFile, CMake
from conans import tools

class OpensslConan(ConanFile):
    name = "openssl"
    version = "3.0.3"
    license = "https://github.com/openssl/openssl/blob/master/LICENSE.txt"
    author = "Jay Zhang <wangyoucao577@gmail.com>"
    url = "https://github.com/openssl/openssl"
    description = "TLS/SSL and crypto library."
    topics = ("openssl", "ssl", "tls", "encryption", "security")
    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False]}
    default_options = {"shared": False}
    generators = "cmake"
    exports_sources = "../../../third-party/openssl/*"

    def build(self):
        prefix = tools.unix_path(self.package_folder)
        args = ["--prefix=%s" % prefix,
                "shared" if self.options.shared else "no-shared",
                "no-tests"]

        if self.settings.os == "Android":
            print("path={}".format(tools.get_env("PATH")))
            print("ANDROID_NDK_ROOT={}".format(tools.get_env("ANDROID_NDK_ROOT")))
            path_prefix="PATH=${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64/bin/:${PATH}"
            print("path_prefix={}".format(path_prefix))
            self.run("ls -lh ${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64/bin/")

            # https://github.com/openssl/openssl/blob/master/NOTES-ANDROID.md
            args.append(" -D__ANDROID_API__=%s" % str(self.settings.os.api_level))  
            if self.settings.arch == "armv7":
                args.append("android-arm")
            elif self.settings.arch == "armv8":
                args.append("android-arm64")
            elif self.settings.arch == "x86_64":
                args.append("android-x86_64")
            else:
                print("unknown android arch {}".format(self.settings.arch))
                os.exit(1)
        elif self.settings.os == "iOS":
            # TODO: 
            pass

        self.run("{path_prefix} ./Configure {args}".format(path_prefix=path_prefix, args=" ".join(args)))
        self.run("make -j $(nproc)")
        self.run("make install")

    def package_info(self):
        self.cpp_info.libs = ["openssl"]

