class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-21.7.0.tgz"
  sha256 "58d525776d859901ccbd0745fd341d77b74556b88b89b0924aa16e81c924fb36"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "81a1c931a22843aae95ef99cb9d12378b363b382829a72c926d778d60d5e68ad"
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
