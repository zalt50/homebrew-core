class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.53.tgz"
  sha256 "e46a72d5c654a45376b5a1814a371e4c63fbc706e06f6f0a9ec41110cd097dbe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a2580cf7945fd0bef96b9267bf47f55539ce65e841d1311faa90677b552b5af5"
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
