class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://wproxy.org/"
  url "https://registry.npmjs.org/whistle/-/whistle-2.10.5.tgz"
  sha256 "fa482caeea9a4c63379fb2d190713ee11d105004fd8b853cc832150d86291f4a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b5d5cbe4cabdd3d98df6b60b6c2b0d7efb91a3d4ceaa94f48055661f21ea4c4e"
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
