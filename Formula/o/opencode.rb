class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.134.tgz"
  sha256 "a08a61d4bb765d48ef18ee8ae8197af60c82c7770e22adb8a95c9d7477ba41f9"
  license "MIT"

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "8fabbee2a0504564c13c954fa02219d11e35724d2c19b3468bcb42125ea3db51"
    sha256                               arm64_sequoia: "8fabbee2a0504564c13c954fa02219d11e35724d2c19b3468bcb42125ea3db51"
    sha256                               arm64_sonoma:  "8fabbee2a0504564c13c954fa02219d11e35724d2c19b3468bcb42125ea3db51"
    sha256 cellar: :any_skip_relocation, sonoma:        "feef57dc5e8ff4e736a6e0ea1df020935212bda6351f1e45ce6e36747b718c2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "feb6d06b46c53965388f311986fd291af6b09b03c93f64db3e61c3aec4c28fe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "deec639e45850a3a32f2200132d38441d0921ce585ca7db70c6da95d358a7c6c"
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
