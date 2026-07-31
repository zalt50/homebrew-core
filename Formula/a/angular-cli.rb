class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.1.1.tgz"
  sha256 "74667250856fadcc0975d3c301b4f74484f7fd0338043f74784f081740be6979"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c0c61625f2bf464dd33165ebc0aaf38f38603f9d56bb4c90de7fa690581464e6"
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
