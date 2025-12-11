class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.147.tgz"
  sha256 "e0f966b4fa45b5b626425afee41b96c8a8683fe68d549c4549d5a67b92b8090c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a1278e85e08ce244df00ba69714a972994cc9d1662487b8bf41ebb5e22bea883"
    sha256                               arm64_sequoia: "a1278e85e08ce244df00ba69714a972994cc9d1662487b8bf41ebb5e22bea883"
    sha256                               arm64_sonoma:  "a1278e85e08ce244df00ba69714a972994cc9d1662487b8bf41ebb5e22bea883"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f466c83f8459ec22af090d0f2ea99c7a6a17acb7c8df2663d61518d71c716a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d2f7298d09dc1602923547168ac586d039a9ae88c1edca54f24455944258e30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e729fc4844bc3d21d6e510c2aba9898110c90b5267f34948d9596b9e7ba96d7"
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
