class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.127.tgz"
  sha256 "53875118306538727a17e8e70e579a7b0ce6252c7759618d13f47d5bb50a7993"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "acdff2d758f42d5247c3950f819c470a906d93559d286a4d0045c86631a79fe3"
    sha256                               arm64_sequoia: "acdff2d758f42d5247c3950f819c470a906d93559d286a4d0045c86631a79fe3"
    sha256                               arm64_sonoma:  "acdff2d758f42d5247c3950f819c470a906d93559d286a4d0045c86631a79fe3"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa304eae70724328c20e8b195837eb552351ae6d27b0fa1a77e1b6ae0290a9f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "869928120e15c06e9d290ac13b07c777efb1e7d8da1268df0022b1e204cab86c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bce1be3004eb5a883676cf807a308779b4a9da6002070d5d1317ed458291e7dc"
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
