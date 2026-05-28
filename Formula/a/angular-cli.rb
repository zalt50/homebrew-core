class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.2.13.tgz"
  sha256 "7e522483544bac61c6939d0fddf45d7a41fdf6fddd585c3101f0d96e85fb2ae3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d865872390f3be786a3c9981add4e08aefc1a5c7129d083e938c82dc3f2ad310"
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
