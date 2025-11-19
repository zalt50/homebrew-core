class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.3.11.tgz"
  sha256 "aa0bef6c7ece7449e531bec2e0b217b29b914fe05e434e01d18a205fe798bd54"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6a7c84c9429d6b634eb5df4fa3aa450d2be1b784dce2ea607944ab6a1b521b8b"
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
