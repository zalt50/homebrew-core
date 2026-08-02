class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.44.tgz"
  sha256 "2b036c758d3bb245bd328e54bd2da81b067958189832ddd0aa2da7ef99085fad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "213d2fcfd8ff84f2b6db1cb345a4c1b19b5ba598a17f61aed003a11110949676"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
