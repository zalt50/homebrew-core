class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.170.tgz"
  sha256 "14b31837a4736368396d1b350bc15868b9767f49ed531ac564deaa7162a47acc"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "ca2f7dfa8e6b095ef085cf97107a9783ffb7ba759a9ae143bf96b2184ddc50ff"
    sha256                               arm64_sequoia: "ca2f7dfa8e6b095ef085cf97107a9783ffb7ba759a9ae143bf96b2184ddc50ff"
    sha256                               arm64_sonoma:  "ca2f7dfa8e6b095ef085cf97107a9783ffb7ba759a9ae143bf96b2184ddc50ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "56f38264db05bf1f187ae40bd5149f82302214aa95455a8d1e546764d5c555ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad2bae63c2d2f746f78f5a21987e1a4b6fd6c637443ea470fe14e43e461b91b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47e3ed35adfa0797e56df75023df5615e52ca34fea735496f26e6b7ed698b6d6"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
