class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.125.tgz"
  sha256 "1a21cf446d1a39044f9cdc6530975d5659ba8a18c1c2869591556ddbe867c5c2"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "4759f46b4aece0540a15a54ea0adda34261038015d60abbf3d8ee935b370917d"
    sha256                               arm64_sequoia: "4759f46b4aece0540a15a54ea0adda34261038015d60abbf3d8ee935b370917d"
    sha256                               arm64_sonoma:  "4759f46b4aece0540a15a54ea0adda34261038015d60abbf3d8ee935b370917d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d1cd88987eb64af28418759fd7c2652d6d36997b6d51581aa6b693ad597796d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86a91c17e150641003419c2d78646ad8de9544936270ffef9ad8f590dd33249a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5378db1706059b25eee380160ef3503f4229a8991bf4375c9c1a38baf40d45e"
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
