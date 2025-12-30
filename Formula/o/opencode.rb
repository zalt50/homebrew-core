class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.212.tgz"
  sha256 "a1496805c1e8979b17a57ee1dc465edc38ea528e1f4579b4483cb00688a38167"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e959eea39f280a238de67afbd67790481cfc772dc7ac44439c641a53bbf83d7b"
    sha256                               arm64_sequoia: "e959eea39f280a238de67afbd67790481cfc772dc7ac44439c641a53bbf83d7b"
    sha256                               arm64_sonoma:  "e959eea39f280a238de67afbd67790481cfc772dc7ac44439c641a53bbf83d7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "96f6248a3f8a0171fbff4baa2e5398d122704ec4a8e5ac323b9eadddc3705200"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d979e1f3a7358a362d4bb7623da6ddc9229e64327cda70e8b2ebf58d92f1f9ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99767921decf7d89eaf5d90df711d645bd4615201e07123f073b7ac03123e014"
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
