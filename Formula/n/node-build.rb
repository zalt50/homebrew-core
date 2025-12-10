class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.4.22.tar.gz"
  sha256 "220ae2d9479ea874abb521a7f3d2d618829a2e8e8d873a1c01b79bd62d3f4a32"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "75ae9d896fb5dbeeb881c806e218c61e450e0a3f29fa340d2ebb0c47026d8f17"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkgconf"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system bin/"node-build", "--definitions"
  end
end
