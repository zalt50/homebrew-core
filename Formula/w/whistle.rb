class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://wproxy.org/"
  url "https://registry.npmjs.org/whistle/-/whistle-2.10.10.tgz"
  sha256 "f04b0744547cffc03aa18efb56949db3bdbfc787466b7773246fd7d5aa347def"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8d79daa16f23912c36f8c69362cbc0be1d14b93f8a226805b97fe63ddcf05852"
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
