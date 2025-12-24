class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.198.tgz"
  sha256 "c14d51f36356dd54d440105108e71db6e868955a7e949c95de191ed575a6d14f"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "fc3740bbdd8232062f48e575985d382f7582fb10819fd5700ba8f35891e8de37"
    sha256                               arm64_sequoia: "fc3740bbdd8232062f48e575985d382f7582fb10819fd5700ba8f35891e8de37"
    sha256                               arm64_sonoma:  "fc3740bbdd8232062f48e575985d382f7582fb10819fd5700ba8f35891e8de37"
    sha256 cellar: :any_skip_relocation, sonoma:        "71fe658d5a953f29be1086d72e0638b448bb4018426b38c67cfd8891253cf8b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "733458005c186371504f8e24030add12ecd831c7caa9e753745099e9ab28b295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59331451ee1e5a1a76f25a4b9c611e4446f75b6b94afc48a0c99c5a5f292cc3e"
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
