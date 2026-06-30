class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-20.5.0.tgz"
  sha256 "9bea6fe87abe70837fe10a432b160cb2acecd4843d7e6c1ad0317b16473e16c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cefa4ea75187b0c97bfac76dc304fe073b469d06f5cd4ce28690fa3f90a286e1"
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
