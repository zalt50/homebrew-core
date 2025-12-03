class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.7.0.3/sox_ng-14.7.0.3.tar.gz"
  sha256 "969446ace6452a91d7bb5e3d908cadfd57fac05dfd99baa812001474bf68fa63"
  license "GPL-2.0-only"
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "caa3e684e47c5ed98e481b25dae7ba8f97cb3a39fa91090b229c1d8a2f270b28"
    sha256 cellar: :any,                 arm64_sequoia: "8ddcf901afd1f44705b6e1117108ea7296e5b4c1816fc6fd1bf463cc0be5ffd5"
    sha256 cellar: :any,                 arm64_sonoma:  "1ff2829c3f2724779a49724cc7d1d00e7237d1a5c8bb2fddc2e7dd098183c6ae"
    sha256 cellar: :any,                 sonoma:        "c6ee591f1076aa714064b9df973a9f8f544326963364d188b81467c1f0cb0e2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c184a88cfd19882e089496c52badd45f83310ba6738f8894be9aaea0ba44419e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4e9c1dc027d65fc5dddad83d47c7f2da7a32728d3b18339a4e418063b89b25b"
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
