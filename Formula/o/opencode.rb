class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.217.tgz"
  sha256 "4f19d08da73f04b35992e922a8d8840e076b02c0ea835564277c7615c9b1402e"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "9dffb2af67eeffcf2c22259ea1846be536199ef1358e03ffb2a74b4cfadedeff"
    sha256                               arm64_sequoia: "9dffb2af67eeffcf2c22259ea1846be536199ef1358e03ffb2a74b4cfadedeff"
    sha256                               arm64_sonoma:  "9dffb2af67eeffcf2c22259ea1846be536199ef1358e03ffb2a74b4cfadedeff"
    sha256 cellar: :any_skip_relocation, sonoma:        "cba379978eaa88875bc6e2cc0ae2bb6f1797e6d216b1b081642a84d6d061fa0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e532dcbe085bf7e9b580c12cd462bd206004f7132c4e0dc84b8dc6ee3ee9975c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "896dd8913ee4c5c55d967ab648c8bd8146818262895f00761749b2b695c68d06"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
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
