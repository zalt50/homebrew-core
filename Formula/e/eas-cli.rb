class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-24.7.0.tgz"
  sha256 "50bf844517c5d022fefe9463f01a1a6dc37f52c765de1895245a3e19666d2e81"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "10ca978687c64376030e9c3469f85c7e07fd9fa42ee0103850ea206aa3b2c6ef"
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
