class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.191.tgz"
  sha256 "9840afb87a4a1c72c9e11492a9b1dea21eaa6381ae3d1799147c0cd5c0955167"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "3686754502df49ac3ebaddf12973fca9569ad65a5397619509787dd93997edcc"
    sha256                               arm64_sequoia: "3686754502df49ac3ebaddf12973fca9569ad65a5397619509787dd93997edcc"
    sha256                               arm64_sonoma:  "3686754502df49ac3ebaddf12973fca9569ad65a5397619509787dd93997edcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "119dbeec1c3dc0b7485e3f23245850ae3bcc2bc227bdd359dd07692f383b2e22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "deec694bdb9b9e3a1118981f8510c8b40bd7d9393a04d6e82ae935d72f8187d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11e6d714d2f9b48c5bfa689e5a448f8a62d8724bd8a784d9e23373e507e99709"
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
