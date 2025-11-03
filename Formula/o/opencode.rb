class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.15.tgz"
  sha256 "b4344142b8f3315ce95e884855c560a6c768ba4a20b71132bb722129513a6ce9"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "db5d0bc8456f758aae7d68e3445e152d1d61ef16ed4a7c987c86e49791b13f6c"
    sha256                               arm64_sequoia: "db5d0bc8456f758aae7d68e3445e152d1d61ef16ed4a7c987c86e49791b13f6c"
    sha256                               arm64_sonoma:  "db5d0bc8456f758aae7d68e3445e152d1d61ef16ed4a7c987c86e49791b13f6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2795e3beb124f1d38178d5bb8407ee3063b6dd24fef972418f7a50a51b3cccd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c8f239a8c9e9196cb2b755fae32aa263292dc68d3e2a0b70c6ab4de9be85241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4beb9c1c1eaab0c4dba4e74b01f5db6f12d73669b1cf356ef975a8ae3e83e958"
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
