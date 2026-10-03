class Xorgproto < Formula
  desc "X.Org: Protocol Headers"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2026.1.tar.gz"
  sha256 "7fa90e48cbaca6bc4c99d176e88c5c147ab0ed42358e14a0869ee9c8a610ae7e"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/href=.*?xorgproto[._-]v?(\d+\.\d+(?:\.([0-8]\d*?)?\d(?:\.\d+)*)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bb28476c91cde66390523a0c33d94e6b4cb0618c65989b6cf1e65bda49328abe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c65163b3daadd9160d9e2ba92f0541800577833c6b06b50c10aab69c1ce38f25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c65163b3daadd9160d9e2ba92f0541800577833c6b06b50c10aab69c1ce38f25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "c65163b3daadd9160d9e2ba92f0541800577833c6b06b50c10aab69c1ce38f25"
    sha256 cellar: :any_skip_relocation, sonoma:            "c65163b3daadd9160d9e2ba92f0541800577833c6b06b50c10aab69c1ce38f25"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "22b221145e4420b8d0444ff4699d93726fc20c63ec1c789b41acf35075174a6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "22b221145e4420b8d0444ff4699d93726fc20c63ec1c789b41acf35075174a6d"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "util-macros" => :build

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "-I#{include}", shell_output("pkg-config --cflags xproto").chomp
    assert_equal "-I#{include}/X11/dri", shell_output("pkg-config --cflags xf86driproto").chomp
  end
end
