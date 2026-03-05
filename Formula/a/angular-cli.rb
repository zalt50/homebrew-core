class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.2.1.tgz"
  sha256 "8741dfbdfd41ac957fcf5257b89b9543878879a6a9bb09dd891f776d4571df22"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "146415599c7b17539a01147a29b883bdb3afe5333219b9b752dc7ceaf292521b"
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
