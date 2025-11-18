class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.74.tgz"
  sha256 "129b672e9ea1632bc9be12343006ec4ce93a629dc965641771f1b35eeebbd5f8"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "fdff3b655e1b8279f029d6e9fdc122c20bfa894eb1df859ad40efaee954994d4"
    sha256                               arm64_sequoia: "fdff3b655e1b8279f029d6e9fdc122c20bfa894eb1df859ad40efaee954994d4"
    sha256                               arm64_sonoma:  "fdff3b655e1b8279f029d6e9fdc122c20bfa894eb1df859ad40efaee954994d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ef5931c6ab29d0c0d2c9a7572ff15e1d39c96b0e038b62caff37ebe78184155"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f98b8c50c769dc42425f6ff70bf1daa14f3bf03bb7b893e89fe3d261da4eb838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cc4420526400aa3601db3b406716d6acd0ec07897ee1a971e21ea04ec1cb4ea"
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
