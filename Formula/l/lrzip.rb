class Lrzip < Formula
  desc "Compression program with a very high compression ratio"
  homepage "https://github.com/ckolivas/lrzip"
  url "https://github.com/ckolivas/lrzip/releases/download/v0.7.2/lrzip-0.7.2.tar.xz"
  sha256 "2954d650633cbb3134ca023f50990cd460c891e1d0518824850213a84c9ce1a3"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/ckolivas/lrzip.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "eb408946ef673448b1c1d6d14d2f86b5319aa28bb3f0fc22f068a491ccdf26f6"
    sha256 cellar: :any,                 arm64_sequoia: "12594f990be465df28cd2eda0b23e0daccbf9f1169cf72b0e4427b1e1015de1a"
    sha256 cellar: :any,                 arm64_sonoma:  "1c6abd74fb352de7f2fbb41a9335d5b8104124649e1116457a68db5eeecc9dc8"
    sha256 cellar: :any,                 sonoma:        "d5ff4085aae34410488f4a1de66a8725bfe4a402a29d567aa31fae7844f19e91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5b9e0d8a3a15533dfb3cd1486db03ae5288ba4d910651d79d3b9b0929c1d3ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a051eea9d0b7d80d0f6f42d8be47e98c88aa51edf17a3fad1d87e875ae4f3b6"
  end

  depends_on "lz4"
  depends_on "lzo"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "lrzsz", because: "both install `lrz` binaries"

  def install
    system "./configure", *std_configure_args
    system "make", "SHELL=bash"
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.lrz
    system bin/"lrzip", "-o", "#{path}.lrz", path
    path.unlink

    # decompress: data.txt.lrz -> data.txt
    system bin/"lrzip", "-d", "#{path}.lrz"
    assert_equal original_contents, path.read
  end
end
