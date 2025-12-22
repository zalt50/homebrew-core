class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.186.tgz"
  sha256 "b28906685a17b9fe468de65178be5845a945a3e61048d336f42141813858579b"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "5352fb11ba0938c4cc0e6f376a4b13c896d8f097e44617931e358c04a0c595e6"
    sha256                               arm64_sequoia: "5352fb11ba0938c4cc0e6f376a4b13c896d8f097e44617931e358c04a0c595e6"
    sha256                               arm64_sonoma:  "5352fb11ba0938c4cc0e6f376a4b13c896d8f097e44617931e358c04a0c595e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d486aa3979647c8e8a348c976c7ee62a7355987a3d3bcf66849409ee4ed3f9a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6d99e4846108d66bb4e0f81170a1f6a0f4955832ce7eb9f3a99e3b5a1d6b217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61d53a64d1474ae24c79dba519a0f8a49a3f3022a7019710589acab31604bff1"
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
