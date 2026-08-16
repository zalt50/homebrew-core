class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://github.com/nift-dev/nift/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "ff31a12f7ca78847d3a63e04db063cebc84bc2bc9c9bcbb4137447008507dfb6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "cffde6265d86b958248a1f0acbb45874f3319a9fed29b5bac84afc5bd1f9799e"
    sha256 cellar: :any,                 arm64_sequoia:  "ec431ecc4b58ffa4a1a11fee47560dacd95b7868b4a49510d760e63c5d509d69"
    sha256 cellar: :any,                 arm64_sonoma:   "d956ac86be1b6ba12faa5fd44203b5528e7449118bf10529ccc92b9e99870cdd"
    sha256 cellar: :any,                 arm64_ventura:  "a7b8a8bb2bae90045ea083bb172b1209c3a9afb6cd7c23dcb9daaacb33a8a5e3"
    sha256 cellar: :any,                 arm64_monterey: "318f8e6c52625ac950dd133d0842f679b8fdfcfcf81291e7c62681dd9841833d"
    sha256 cellar: :any,                 sonoma:         "be9f28e1d59a40c8f7eb2ef64706389a7e3983ecc884072c925fd4ea5f058d4a"
    sha256 cellar: :any,                 ventura:        "c2261dd8442c08a37c268f6b5192abfed469b4edbde6bf640873a8db0f1c78f4"
    sha256 cellar: :any,                 monterey:       "a72728301c2f93e669868c547353a2bc1cb09d68a8bd0a14ebeab4556877e2fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0fe98d910ca3b4ddaf7ba53a135e62cc0fb506aeae507482b0fc85af9f78eaf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4ceda3cb7527a85aac01357fa0e8fe3a1adb2d8dc4be618b7e93cacd97e6754"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"nift", "init", ".html"
    assert_path_exists testpath/"public/index.html"
  end
end
