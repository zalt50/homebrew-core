class Retire < Formula
  desc "Scanner detecting the use of JavaScript libraries with known vulnerabilities"
  homepage "https://retirejs.github.io/retire.js/"
  url "https://registry.npmjs.org/retire/-/retire-5.4.0.tgz"
  sha256 "b72eb1e11c5928c32096b3535d3e388f4f39de876aaf26cf8de97888d54e01f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6f06986094a2890fe3bfa46cef5c6692a6a26c212106f3383522d5ed502ae3a8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/retire --version")

    system "git", "clone", "https://github.com/appsecco/dvna.git"
    output = shell_output("#{bin}/retire --path dvna 2>&1", 13)
    assert_match(/jquery (\d+(?:\.\d+)+) has known vulnerabilities/, output)
  end
end
