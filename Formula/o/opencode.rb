class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.182.tgz"
  sha256 "1c35a5cef4e1fe0a395742526727614112d9aafd3f7bad6ce7597d5a1ec75691"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "d2a99ab3d4075fcd4f7b237f89c1e0534602bde9c667a217f35359a3e1e8a709"
    sha256                               arm64_sequoia: "d2a99ab3d4075fcd4f7b237f89c1e0534602bde9c667a217f35359a3e1e8a709"
    sha256                               arm64_sonoma:  "d2a99ab3d4075fcd4f7b237f89c1e0534602bde9c667a217f35359a3e1e8a709"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d146be2997743f65708cb590a9a10d22072cd20e8e2e2aa626d94c13acb7e86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4266b7dde1ec89c4173ebd934ec89f5db77daa014be42a53ac79adf7f13bb214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4760aa3ecbced012e787c8b984eac3be0d09de8caa35f13aa4af831c34143ee"
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
