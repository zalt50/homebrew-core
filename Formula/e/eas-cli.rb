class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-22.2.0.tgz"
  sha256 "abcf50e89b5da72bada22a51f6012d583a309a2c6b0dcfc71ee29c7662498a91"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "13d12c5c0ae6db9e27ede713e9098d79d7267778b920e2e8727ee1ef723ba35c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eas --version")
    assert_match "Run this command inside a project directory",
                 shell_output("#{bin}/eas diagnostics 2>&1", 1)
  end
end
