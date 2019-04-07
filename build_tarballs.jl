const PCRE2_VERSION = "10.31"

using BinaryBuilder

# Collection of sources required to build pcre2
sources = [
    "https://ftp.pcre.org/pub/pcre/pcre2-$(PCRE2_VERSION).tar.gz" =>
    "e11ebd99dd23a7bccc9127d95d9978101b5f3cf0a6e7d25a1b1ca165a97166c4",
]

# Bash recipe for building across all platforms
script = """
cd \$WORKSPACE/srcdir
cd pcre2-$(PCRE2_VERSION)
./configure --prefix=\$prefix --host=\$target --enable-jit --enable-pcre2-16 --enable-pcre2-32
make
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Windows(:i686),
    Windows(:x86_64),
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc),
    Linux(:powerpc64le, :glibc),
    MacOS(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
   LibraryProduct(prefix, ["libpcre2-8"],  :libpcre2_8)
   LibraryProduct(prefix, ["libpcre2-16"], :libpcre2_16)
   LibraryProduct(prefix, ["libpcre2-32"], :libpcre2_32)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "PCRE2Builder", sources, script, platforms, products, dependencies)
