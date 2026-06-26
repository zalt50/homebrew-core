class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-20.4.0.tgz"
  sha256 "316070c76fe6545784c60fb96623ed7c7d485a1e833a5148e073a9f45adbc012"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a37b6981df8e322ff650ac761c4de7e10de76fab8b716099c572fcdc4926a34d"
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
