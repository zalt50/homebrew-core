class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.14.0.tgz"
  sha256 "5db73e515b9987b4bce6cd461cce3494e086d1dfa8d9ade9222bf4e64129006d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c077f23ad09d2b09c0493fc3fa0285549fceed2043dd378ddd9af177489c80fb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/npq --version")

    output = shell_output("#{bin}/npq install npq --dry-run")
    assert_match "Packages with issues found", output
  end
end
