class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-21.0.1.tgz"
  sha256 "d9ad2f48194cbad00c21619248041bc6105870276c7ef4ddd4b6edf157bcf94b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ebef2487d1d3a6b17f20d9c66217b193b10c90144c4922c4a625448c3ef78479"
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
