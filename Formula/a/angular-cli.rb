class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.0.1.tgz"
  sha256 "90a53bae3162f2d31a39af1208131114fc850d0fe1c3094144e5b1e170c6b2df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "150297b56f303eb83e04d07f331bb875bd92d05e5ff30ec06360bb8dc81cb6c1"
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
