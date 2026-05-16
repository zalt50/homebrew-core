class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.15.3.tgz"
  sha256 "be282c09f6d4fe2889b2566b48f0507c52151528490c2a67efeccbe57a7fe317"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    sha256                               arm64_tahoe:   "46dac60dcd1140fd222d2f096766e77e0177992a0d95bcf938f46b59765a402f"
    sha256                               arm64_sequoia: "46dac60dcd1140fd222d2f096766e77e0177992a0d95bcf938f46b59765a402f"
    sha256                               arm64_sonoma:  "46dac60dcd1140fd222d2f096766e77e0177992a0d95bcf938f46b59765a402f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d65546a8afc49bb3e0238d05229482905f095a275e1c42ee9dca4b409e477059"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0f8be4d58054155b6e16e4e8b79f4833844a7855958eecef605e6b578184c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "970588d78c16d0705f367a4b668ac9877cfb7446bc548240a15b71f2af8cb545"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

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
