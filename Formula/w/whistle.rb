class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.107.tgz"
  sha256 "0e851b0362d6621384b493cbeec1320485f585b1b87f9fe91aa26e931271faef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a05fee429885a0bc760d52a26ae64890d477b3bb176af89cbd4a582e1ba7b7b8"
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
