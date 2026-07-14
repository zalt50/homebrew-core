class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-21.0.0.tgz"
  sha256 "c838877c0a57cb9347556f4e01084b1ea5e336bf0b74dc2f6d73929b12c3f538"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3456e8ad9c29cef61c372c10b76ab0792197417cb180f01cf2f3ae32d6d4dd55"
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
