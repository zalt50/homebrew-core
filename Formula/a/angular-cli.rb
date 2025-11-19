class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.0.0.tgz"
  sha256 "c68ed98819105094c86c16451f775f47f7d2176ae3ddfff4147b508c94c248f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f19441550918d0af7a0698803770101062f39c935cb90de16af0d93edaae8673"
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
