class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-24.9.0.tgz"
  sha256 "836a94112c2b3d5d335370c67fffc7f39d9335e9e4cbd595722347a53aebe171"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae5d51eb25504b601d39124537b3aae35ea0b78a51a443c3d01f3b42e3a68dfe"
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
