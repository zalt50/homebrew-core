class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-24.6.0.tgz"
  sha256 "4153dcf8f7d2090adb48869d20b0e874ed5c0ee4455a12e82c5ee3ef599417dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5174240b5887b0795cf01a2b9049c19e03f0f21cb4fb8893d8dfadecde84a1b4"
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
