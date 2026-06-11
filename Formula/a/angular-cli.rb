class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.0.1.tgz"
  sha256 "933016c60de73848d5ec45beb5724816a7a8329134bfaa5c3cca2aec141ccd78"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "04d5a3b462fbc2b339c55a713117615fb2e0d49aee85c7bc3bb336dc12568832"
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
