class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.0.2.tgz"
  sha256 "3c9268ee7441012ecfb54f741de8eccf66974a76d98ca7f50ca50b6e3c96465c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "29f4fd62ac62bd1f7376b1ae26242d6fe95b612480c3b112f8f4fccfe8f5b115"
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
