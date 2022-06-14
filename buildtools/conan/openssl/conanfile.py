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
            # self.run("export PATH=${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64/bin/:${PATH}")
            self.run("echo $PATH")

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
            # https://github.com/openssl/openssl/blob/master/Configurations/15-ios.conf
            # https://github.com/openssl/openssl/issues/15851
            if self.settings.arch == "armv7":
                args.append("ios-xcrun")
                # args.append("-fembed-bitcode")

                # Fixes "Undefined symbols for architecture armv7: ___atomic_is_lock_free"
                # see more details in https://github.com/macports/macports-ports/blob/f543051794963064ea924697f7a33428936fbe2a/devel/openssl3/Portfile#L132-L136
                args.append("-DBROKEN_CLANG_ATOMICS")
            elif self.settings.arch == "armv8":
                args.append("ios64-xcrun")
                # args.append("-fembed-bitcode")
            elif self.settings.arch == "x86_64":
                args.append("iossimulator-xcrun")
                args.append("-mios-simulator-version-min={}".format(self.settings.os.version))
            else:
                print("unknown ios arch {}".format(self.settings.arch))
                os.exit(1)
            args.append("-fvisibility=hidden")

        self.run("./Configure {args}".format(args=" ".join(args)))
        self.run("make -j {}".format(tools.cpu_count()))
        self.run("make install")

    def package_info(self):
        self.cpp_info.libs = ["openssl"]

        # for android building
        if self.settings.os == "Android":
            # openssl requires end with something like '23.2.8568313', but github hosted runner use `ndk-bundle` soft link
            if "ndk-bundle" in self.env_info.ANDROID_NDK_ROOT:
                self.env_info.ANDROID_NDK_ROOT=os.path.join(tools.getenv("ANDROID_SDK_ROOT"), "ndk/23.2.8568313")
            self.env_info.PATH.append(os.path.join(self.env_info.ANDROID_NDK_ROOT, "toolchains/llvm/prebuilt/linux-x86_64/bin"))
