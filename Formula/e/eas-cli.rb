class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-21.5.0.tgz"
  sha256 "7e94cd527ec80a4e8b561b44718881a79bcebfe7390c2d8e2484d29cfd0aa33d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "031ad8d6b5a7ab29d3039a4d7c7db069543c52072270992e9e0804d239f0a416"
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
