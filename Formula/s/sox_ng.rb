class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.6.1.1/sox_ng-14.6.1.1.tar.gz"
  sha256 "818583847dcd9bd5f66b46d71a50087a057501a1456e6f79d4ea267971efdcbf"
  license "GPL-2.0-only"
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "73aeb68fd1954e6d0e97a0cec72d8803e99623314537dfb0568c1c2cffaa409a"
    sha256 cellar: :any,                 arm64_sequoia: "3589b926627f722cbf5ce5cfdb1100f254014be3bf7bbc8ff0f0b0bfb0fc9354"
    sha256 cellar: :any,                 arm64_sonoma:  "3919ac06a6a3ec67e5974c2ee9498dfe0bb7c0d062829196dc7eb2328fa71e71"
    sha256 cellar: :any,                 sonoma:        "1ac59a6233808d5dbb9c9b8427b4ac11760706fe988376bb52bf3a34877e20ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5a85a53e7cd895a0e86794695ee2e4c235bc18f26387df2da38d612c65ce60f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a1ff9a84fc693ccbf8f71b89f91837719a26cfc896f2d5bec0b2552a6a3d1c9"
  end

  depends_on "pkgconf" => :build
  depends_on "flac"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "opusfile"
  depends_on "wavpack"

  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
  end

  conflicts_with "sox", because: "both install `play`, `rec`, `sox`, `soxi` binaries"

  def install
    args = %w[--enable-replace]
    args << "--with-alsa" if OS.linux?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    input = testpath/"test.wav"
    output = testpath/"concatenated.wav"
    cp test_fixtures("test.wav"), input
    system bin/"sox", input, input, output
    assert_path_exists output
  end
end
