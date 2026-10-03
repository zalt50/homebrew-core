class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-24.9.0.tgz"
  sha256 "836a94112c2b3d5d335370c67fffc7f39d9335e9e4cbd595722347a53aebe171"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "08038664423d5de960212a0a77b75a9d88cd865bec6981ee9fab137a724a1004"
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
