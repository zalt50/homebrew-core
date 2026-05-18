class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v8.0.5/deployer.phar"
  sha256 "0026dfa73626a8ccde06222fe5fccf03e6d4a19e765914bb87d7d2cc21f3e57d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ea06a2e895fd82d32abf6c9f597591c3898464ec76bc020f1656dbd4cfdc6aac"
  end

  depends_on "php"

  def install
    bin.install "deployer.phar" => "dep"
  end

  test do
    system bin/"dep", "init", "--no-interaction"
    assert_path_exists testpath/"deploy.php"
  end
end
