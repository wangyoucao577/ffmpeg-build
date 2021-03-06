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
                "no-tests",
                "no-module",
                "-fvisibility=hidden"]

        path = tools.get_env("PATH")
        if self.settings.os == "Android":
            # https://github.com/openssl/openssl/blob/master/NOTES-ANDROID.md

            # android build requires ndk toolchain bin in path
            path = os.path.join(tools.get_env("ANDROID_NDK_ROOT"), "toolchains/llvm/prebuilt/linux-x86_64/bin") + ":" + path

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
            # https://github.com/openssl/openssl/blob/master/Configurations/15-ios.conf
            # https://github.com/openssl/openssl/issues/15851
            if self.settings.arch == "armv7":
                args.append("ios-xcrun")
                args.append("-fembed-bitcode")
                args.append("-mios-version-min={}".format(self.settings.os.version))

                # Fixes "Undefined symbols for architecture armv7: ___atomic_is_lock_free"
                # see more details in https://github.com/macports/macports-ports/blob/f543051794963064ea924697f7a33428936fbe2a/devel/openssl3/Portfile#L132-L136
                args.append("-DBROKEN_CLANG_ATOMICS")
            elif self.settings.arch == "armv8":
                args.append("ios64-xcrun")
                args.append("-fembed-bitcode")
                args.append("-mios-version-min={}".format(self.settings.os.version))
            elif self.settings.arch == "x86_64":
                args.append("iossimulator-xcrun")
                args.append("-mios-simulator-version-min={}".format(self.settings.os.version))
            else:
                print("unknown ios arch {}".format(self.settings.arch))
                os.exit(1)

        with tools.environment_append({"PATH": path}):
            self.run("./Configure {args}".format(args=" ".join(args)))
            self.run("make -j {}".format(tools.cpu_count()))
            self.run("make install")

    def package_info(self):
        self.cpp_info.libs = ["openssl"]
