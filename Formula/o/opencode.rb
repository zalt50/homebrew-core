class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.208.tgz"
  sha256 "7252b003b1b40dd423460fd740263f499580c88289c93f21fcd0dabad5dca7b9"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "115bfa91369efb538904d6a48fbb86d5f7807ff4a678b46243d6e3181728aa5d"
    sha256                               arm64_sequoia: "115bfa91369efb538904d6a48fbb86d5f7807ff4a678b46243d6e3181728aa5d"
    sha256                               arm64_sonoma:  "115bfa91369efb538904d6a48fbb86d5f7807ff4a678b46243d6e3181728aa5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "82595c504bce3609caf67fb204d6e51cbde9d309b667b058ecd0a3a8045340b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f8fd64e5a82ebfbb1e2f7fd0be3d0ee4db9732a859ff21efd691c3beb16a446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74ec922b8751ab87bea42b686fb06b9b2f4606ac8661632209de2b6714c21530"
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
