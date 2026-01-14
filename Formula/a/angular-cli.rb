class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.0.6.tgz"
  sha256 "19fd164e8d9bd6577c96df94a628f45586a16076f16b655142ffc0218ae46565"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3a6dcbf83b4e9b8c6ed3d44c64275c9528ec02be199458b5f6739cfefe45db08"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end
