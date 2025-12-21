class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.182.tgz"
  sha256 "1c35a5cef4e1fe0a395742526727614112d9aafd3f7bad6ce7597d5a1ec75691"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a27c467b7cfbfad159d913ee9980440998c0fd8d2ed1ab2ceb9408e6d2cbf891"
    sha256                               arm64_sequoia: "a27c467b7cfbfad159d913ee9980440998c0fd8d2ed1ab2ceb9408e6d2cbf891"
    sha256                               arm64_sonoma:  "a27c467b7cfbfad159d913ee9980440998c0fd8d2ed1ab2ceb9408e6d2cbf891"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e5a686d547646c34fa2c0e6d75840bef67f5fcd64b11bddf305bbbc1a7dab93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fed823d452a6119df1bd615f5f7dd0138f22f341f4b0411eeaa520645303eb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6729ab5f0afb228d9b160d254b8ba14456552a3cbc8eee5077048a4ecdfb4b4e"
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
