class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.26.tgz"
  sha256 "7f575e31725caf3d6a49ed75a72ed87e51f664b7a1f6b91c2e8b4b9c6c668b3b"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "da7dcddfb9c9124e2f329181d42b68a82a1bc02e237876c0f93952ea06adce9e"
    sha256                               arm64_sequoia: "da7dcddfb9c9124e2f329181d42b68a82a1bc02e237876c0f93952ea06adce9e"
    sha256                               arm64_sonoma:  "da7dcddfb9c9124e2f329181d42b68a82a1bc02e237876c0f93952ea06adce9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "deb5ce65eb3870dbeffe0340a9a8174ad387a6032d9ee0b1ed99b956fbe14305"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e5add490aee41334e254515efe576ee3faf9d244eb1f5126c4b2c42f97bfa43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21598b8923ea8d4bbd01baaa6d8b917738c9fab2911c0c5dcf18a148138f383a"
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
