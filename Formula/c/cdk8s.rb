class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.61.tgz"
  sha256 "0fff77c8e1e2faaa8aab706aa65d20759d406b0a75400315621d899af78cee54"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8b06b425ec63db57937610d3ff6e5bd2a1f7e394c3b7cd912409ebf8482686e6"
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
