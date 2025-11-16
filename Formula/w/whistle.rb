class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.104.tgz"
  sha256 "3d627aa1ab6b99218483f83520cc7018eec77e825851683a89754126b3bf284f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1bf19b5fa547f48ce9837ea29c611a73bdfee5bb5e35c5bdc3eb9404ffe86233"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
