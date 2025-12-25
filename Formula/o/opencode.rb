class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.200.tgz"
  sha256 "5165e95b5892841b644d7547be63b988ddb1a3a86f2051d218534bad5157084d"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "c2471df8e0f49d9aaa4f27ba61184600a5c66773fc604b353bfd3aec8a0d5ec7"
    sha256                               arm64_sequoia: "c2471df8e0f49d9aaa4f27ba61184600a5c66773fc604b353bfd3aec8a0d5ec7"
    sha256                               arm64_sonoma:  "c2471df8e0f49d9aaa4f27ba61184600a5c66773fc604b353bfd3aec8a0d5ec7"
    sha256 cellar: :any_skip_relocation, sonoma:        "891375125aae41d40962e39978f8448f4bafa6601e8fc1b7b162da2fd398490b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be5afb802b116e1b746ae3200f8b4fe55564061bc74a3fd414173d6f4e82d2f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7690f25305e2e3653cee4f4ab61cb3e0e5fe909136264b3b0736eccaa8c84de"
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
