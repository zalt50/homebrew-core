class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.1.0.tgz"
  sha256 "e28017fc2b08b8c27aaa26351494eae9d9800bb2116ee525b6d21990cdb65cb7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eb1464eac6eb24d14ab4a7f9475dcfc48bf5ba944dd1d3e051c4b28e6920497f"
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
