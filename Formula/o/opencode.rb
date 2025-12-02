class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.127.tgz"
  sha256 "53875118306538727a17e8e70e579a7b0ce6252c7759618d13f47d5bb50a7993"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b19e044827d8d12647d422fc994e8f88168c70972d68f8440e76df9172af8d56"
    sha256                               arm64_sequoia: "b19e044827d8d12647d422fc994e8f88168c70972d68f8440e76df9172af8d56"
    sha256                               arm64_sonoma:  "b19e044827d8d12647d422fc994e8f88168c70972d68f8440e76df9172af8d56"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1df2ac2a4108f6e927c7c48bbbd947d241c549ce48c022d153d7a404085ab98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "214dc01f020a64ada066144ac188c892fd09ab14f9802c1de17ac658178a0f0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1a487dec2f931280071f76439a54b08dd4d17b91cd250118982d11857b7c2d8"
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
