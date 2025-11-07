class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.44.tgz"
  sha256 "11f041b5af678e9b8e054821ce9b2158d362d3231045c3312bbabd8641cbaefd"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "87dbe52834fb96fbc8aba57fa5bdf57e46ce71e091a1dbe4ac355009e09aa4d1"
    sha256                               arm64_sequoia: "87dbe52834fb96fbc8aba57fa5bdf57e46ce71e091a1dbe4ac355009e09aa4d1"
    sha256                               arm64_sonoma:  "87dbe52834fb96fbc8aba57fa5bdf57e46ce71e091a1dbe4ac355009e09aa4d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "625ae290ca4535053ceb00dbe4a09d0e83bf354a23c57bf4c408202820a0211f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bcef697a4e987d9fbd4aba7014651e3961c8c256047bb6ca4987b2297c2a892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70367d9ee8f9d07e045887a6d6a9f7ab44bc0c0bf14bce9fbd374807135a3627"
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
