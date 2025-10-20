class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.15.10.tgz"
  sha256 "f651f65e049e05cd3fff577c379c25b042dd51160ac5064a285dec317cd233ad"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "32d11642665044795983dbd56a74ced33e9c40192d48f871af0ebed57431bb49"
    sha256                               arm64_sequoia: "32d11642665044795983dbd56a74ced33e9c40192d48f871af0ebed57431bb49"
    sha256                               arm64_sonoma:  "32d11642665044795983dbd56a74ced33e9c40192d48f871af0ebed57431bb49"
    sha256 cellar: :any_skip_relocation, sonoma:        "49b1a25aa77d6c776c2c63f217b98f54f3fa15ad61026d8f4568522f046c8cdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e5c93b1f9b878dda06ae9fb74b26ba6bd5a9986244e674ad66484a1c385b166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "179ac11afd0802e3f4448dd7b6f1336ece9aa459d02a4f9ff3f5e69359198fb6"
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
