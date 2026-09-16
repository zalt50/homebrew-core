class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-24.5.0.tgz"
  sha256 "e14a43954840b2c27ba9893c1f93f16304b4f81b7db2648ad3d4d8abf5c470db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d134027da50497ed575d7311a6b327fd5417d35feb668fda582e559bf004c063"
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
