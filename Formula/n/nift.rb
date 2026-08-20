class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://github.com/nift-dev/nift/archive/refs/tags/v4.0.4.tar.gz"
  sha256 "7e3772be753e94cac1e6845573ccfb5b93c8232c62c45abed960e36e3d14319e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28498b97afc4ab31887d53022bd5df4509d2c6d96886028e30117af7955c626b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f7bd119db9674ebfae95aa92e250f667fc1b1cc903005b47c6abf3e99fc55bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00bb81e0521058b339b2d800cfb1c518e31d3aa2735520b55c5c293af04ea256"
    sha256 cellar: :any_skip_relocation, sonoma:        "d31ca1f3bf56f10fbe08db1e0c405d69df0da04a5961fba95fd38f5c5dc92423"
    sha256 cellar: :any,                 arm64_linux:   "99a0da294520118d299165586845c9bbf707c387243e00f66dcd1703173b3dd3"
    sha256 cellar: :any,                 x86_64_linux:  "a99d1df43956aafcb851d36b4995eaad11486279f18b53faef01253e7907fe99"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"nift", "init", "--ext=.html"
    assert_path_exists testpath/"public/index.html"
  end
end
