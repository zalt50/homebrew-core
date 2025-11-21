class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.83.tgz"
  sha256 "ce3ba3854aeec82225c3022e09b10decf5a049754890cac10f20a76b83495b41"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "3477176c67d320c34f85d010813712850ea533ad724732d97bc1b3b0807ab913"
    sha256                               arm64_sequoia: "3477176c67d320c34f85d010813712850ea533ad724732d97bc1b3b0807ab913"
    sha256                               arm64_sonoma:  "3477176c67d320c34f85d010813712850ea533ad724732d97bc1b3b0807ab913"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a19acc191f22eda879bf5251c26e4b2be55e7d5aac215ade6922ce27bd07ab1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03d3b6a16c5680211677887a7e68138ad085b7ca945cf3f9b2bf04f96144aaf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d196352d7ace6dd01507fc642235139037572776b727157ae157cf859ba3d4b"
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
