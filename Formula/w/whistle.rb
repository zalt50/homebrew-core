class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://wproxy.org/"
  url "https://registry.npmjs.org/whistle/-/whistle-2.10.4.tgz"
  sha256 "11a7534af0c9601f0742e744771b8c8c075df3882386543fc6ca00408dfef66d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7534947d60c957a2e0abbd7cb8625d34827cfe8de7cae98fe7a12cfac06e1794"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
