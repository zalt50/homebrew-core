class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-20.5.1.tgz"
  sha256 "6d2d4dd92c2a5cfe2c288dfc12d67b40a0bd2ef5d9c3d40077f61221d3ef3fee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "835e7b8aa5798344b9b2b9131eef4e2980af03cd105519d5b49fbd5e6e149ace"
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
