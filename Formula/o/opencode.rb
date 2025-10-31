class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.15.30.tgz"
  sha256 "e2a1c0ca735fd37c462739ad16edba07d0aa4764012218b179a46ac6d7c2a214"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "58be61309cf50f77579f9ccd21f24261d707b61221bc055c638cf79f591c95a7"
    sha256                               arm64_sequoia: "58be61309cf50f77579f9ccd21f24261d707b61221bc055c638cf79f591c95a7"
    sha256                               arm64_sonoma:  "58be61309cf50f77579f9ccd21f24261d707b61221bc055c638cf79f591c95a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "683bc818c9a23a5945075b7f09a64ad69dbfbe189a68a0c2dcaa7b212d0cff29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0799d1e6778c94972a526762034d95236b0e9d4c895753a1001d5c09a7d8867d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5431249de1c4df7007047d73722d6e9827256ccc3eb49e0810bdcd304a7766d9"
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
