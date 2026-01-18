class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https://tracker.debian.org/pkg/fakeroot"
  url "https://deb.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.37.2.orig.tar.gz"
  sha256 "0eea60fbe89771b88fcf415c8f2f0a6ccfe9edebbcf3ba5dc0212718d98884db"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/f/fakeroot/"
    regex(/href=.*?fakeroot[._-]v?(\d+(?:\.\d+)+)[._-]orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "564fd8232d47a45c63da8ef9f7dae69e703529215d4a7c486c5c1e21a7065483"
    sha256 cellar: :any,                 arm64_sequoia: "ab29a59c3530a716bfa3151bed5458ece1bb6b136dd2a316f54f88ff031e1f52"
    sha256 cellar: :any,                 arm64_sonoma:  "1aadc43f4ce3f17a1a609750a139f412205a71b1abc068b06874e83e40fcd7f3"
    sha256 cellar: :any,                 arm64_ventura: "1c11f5d0a36d1d27fb51c32f3989802f4c385796b56959da1472c3a97a42c687"
    sha256 cellar: :any,                 sonoma:        "2c240e8fb51287a6e2304c2aca7dc0e0c0bf7103f72b3f36872abaa23d62c0d0"
    sha256 cellar: :any,                 ventura:       "f67ebe96d1e957f934e9de9cb936671f7fef7780e6e12011828265ec2547ccb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f239b1a7a44fed02417a5230512a0a1f06d3c84bd27aff90db9c9a1a5704dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41acec3bc608043a4a49fcca0008b90bbc45abc655d9b1c13b74577df13297a2"
  end

  on_linux do
    depends_on "libcap" => :build
  end

  def install
    args = ["--disable-silent-rules"]
    args << "--disable-static" if OS.mac?

    system "./configure", *args, *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fakeroot -v")
  end
end
