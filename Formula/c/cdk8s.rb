class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.22.tgz"
  sha256 "23dc1ae688675152f7ba3cdef29483d4b774c856497889bbb46150f66b7fe1aa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fbfad457b13e898b3657f670f495bd37fa3797b646fcdf25b4f52c652a34168d"
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
