class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.0.9.tgz"
  sha256 "2b1d1c8b5151b22db80ff926e7aae445fe6b837374289df7dd185b55acb5abf7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2e844206fd4d9c87dfe99797fa5011919c23fe757c0d41e6fa8ea65ae519baa7"
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
