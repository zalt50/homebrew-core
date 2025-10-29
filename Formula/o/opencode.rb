class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.15.23.tgz"
  sha256 "19dd6869cc2b233949e2574d641f9bd5d4595c1f9952212f7a8f8f576caa867e"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "30b7617ee43e6f49d16d2379ad297c5a52d8ad4aca1fea15bc2ccc434f39a92f"
    sha256                               arm64_sequoia: "30b7617ee43e6f49d16d2379ad297c5a52d8ad4aca1fea15bc2ccc434f39a92f"
    sha256                               arm64_sonoma:  "30b7617ee43e6f49d16d2379ad297c5a52d8ad4aca1fea15bc2ccc434f39a92f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0605f124dd1a7ed8a56907a2f5d719c6313a86d88be68877854d2b298417313e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "059accca515300bb5920b67e21b4483db29e32145c4b6fc48da8fe7dbbf123c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9bbe49569d52700e35aff4be8f99faa0c7851c6da36ce71da0d33829901b7ae"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
