class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.23.0.tgz"
  sha256 "189a1e0db0dbae95360154510f1031947a28ae684cde438b4783d3274400b1de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "da0c745fd304dba7ef4920eea3d709c981fb5c16ff5bf88027c965715635e0e9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/npq --version")

    output = shell_output("#{bin}/npq install npq@3.5.3 --dry-run", 1)
    assert_match "Package Health - Detected an old package", output
  end
end
