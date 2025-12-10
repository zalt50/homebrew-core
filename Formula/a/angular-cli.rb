class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.0.3.tgz"
  sha256 "3da53721e39ecc6eca72b544626666406cf46ae8a904a068b7210a549fb66c64"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "22fdd69b9e4f09ee402fd434bd889db3558329dbd2dadf7e788e94d5b59cdb65"
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
