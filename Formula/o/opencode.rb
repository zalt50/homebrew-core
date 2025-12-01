class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.123.tgz"
  sha256 "df6c76d346402b515b50fb4bf8b8817e012f55a499a1f0f9abc8c540f51814b9"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "883ce8f4482c6250e05c046da510c62b61ad05fdcbee656e0484f4f4e7696fc3"
    sha256                               arm64_sequoia: "883ce8f4482c6250e05c046da510c62b61ad05fdcbee656e0484f4f4e7696fc3"
    sha256                               arm64_sonoma:  "883ce8f4482c6250e05c046da510c62b61ad05fdcbee656e0484f4f4e7696fc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b3d966af57849270eb140b09dfaad4e02fdbda99373d8bb0976831dff555950"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d16200aed55ca64b54cfc9e73d4a19fcf11d387af6bf9590d3889aa2c219392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3afaf41f32b317f18c19de023a9c6174836632f6e1abd45f559f33a88dd724c7"
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
