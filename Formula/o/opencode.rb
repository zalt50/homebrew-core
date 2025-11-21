class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.83.tgz"
  sha256 "ce3ba3854aeec82225c3022e09b10decf5a049754890cac10f20a76b83495b41"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "9eadcd8934d98c231c8d38fecb60a59beb7f3a96a14d84a38bcd707f5d16d1fb"
    sha256                               arm64_sequoia: "9eadcd8934d98c231c8d38fecb60a59beb7f3a96a14d84a38bcd707f5d16d1fb"
    sha256                               arm64_sonoma:  "9eadcd8934d98c231c8d38fecb60a59beb7f3a96a14d84a38bcd707f5d16d1fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f10a3e67dfefc78b5a1e93ff74f6d3b68d5a07e1a62aebb6400303a145497242"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5ffd9b8b45d5dfdbc6f2b393264ba22422750f6ec03bafb107c7ef25800f92c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cb097f59929d9fd1b121bb0eda40ab50181b3a26c74b70a0068b1c2c29127fe"
  end

  depends_on "node"

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
