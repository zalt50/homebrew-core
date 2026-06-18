class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.23.tgz"
  sha256 "e0c016f0706d77d363a910284f4dd2580e32316a4b4495d52e0341bd4cf02928"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c5a2f9786985e9dbeb06b6147883d58afa56cdcff7500eee5ef2d0978bde48ab"
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
