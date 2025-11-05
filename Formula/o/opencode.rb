class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.25.tgz"
  sha256 "8f172bd44d613e17087366c48c0e05aeed9f5c20813d9176bdfd1e7695e4130f"
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
