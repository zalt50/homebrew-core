class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.202.8.tgz"
  sha256 "e24ed33e96b098d11184b23083b4cb9c4bd12ec923f27dab07c96a2bb164d48a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c766fb476eb993a91cda189210788081fcc595a99ec2a22b98a864d2231f260"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
