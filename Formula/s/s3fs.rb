class S3fs < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://github.com/s3fs-fuse/s3fs-fuse/wiki"
  url "https://github.com/s3fs-fuse/s3fs-fuse/archive/refs/tags/v1.97.tar.gz"
  sha256 "28413457cbf923b9b81e546caffabb8edd5c18f263e698ad86f564fd4b5b344d"
  license "GPL-2.0-or-later"
  head "https://github.com/s3fs-fuse/s3fs-fuse.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "498ca33627f03956baf1e59675c0dcb84f714d541cd8a06a68927eb3d0949592"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "570753427deb94c2b35cce9af745c36b87c6ab1faebf20d860c180ad94ab6116"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "gnutls"
  depends_on "libfuse"
  depends_on "libgcrypt"
  depends_on "libxml2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "nettle"

  def install
    system "./autogen.sh"
    system "./configure", "--with-gnutls", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"s3fs", "--version"
  end
end
