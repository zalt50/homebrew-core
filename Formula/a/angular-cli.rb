class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.3.10.tgz"
  sha256 "f6153ad3f1b302c97a82168559c2474e8f5f758fbb4a0b09d187cb1766d3f51f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "33cf59a7630ac2be2e606d6ed2f414894547855ac996c7c6a5aa79e2f69e05ad"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end
