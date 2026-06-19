class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.17.1.tgz"
  sha256 "d7890506d13a3b752824446ccd05d4b2aa1e474795abbc28fcc024deed2c140a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "de42405356d3dbbe534507a6bb60c5eb7df238cca146d147c3a56337989148a3"
    sha256 cellar: :any,                 arm64_sequoia: "727688f55ae6ce437af83fa2ec351cdb5f36b8386b24e2b44955b41c7c741920"
    sha256 cellar: :any,                 arm64_sonoma:  "727688f55ae6ce437af83fa2ec351cdb5f36b8386b24e2b44955b41c7c741920"
    sha256 cellar: :any,                 sonoma:        "c86fe492f0c579d37e01a37a35459d82b6b0cd5fe1708335b37394597856d10d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9286fad0a59721e4b3be5e3ad8488e726da15b4f1e400540419999289f1bf95d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "033aa76f5991de0b073dc4e18e6b8f6631648acd1a5ed93fa2e5ded6e21a16fb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    node_modules = libexec/"lib/node_modules/@moonshot-ai/kimi-code/node_modules"

    # Remove non-native architecture binaries from `koffi` and `node-pty`
    if OS.mac?
      other_arch = Hardware::CPU.arm? ? "x64" : "arm64"
      rm_r node_modules/"koffi/build/koffi/darwin_#{other_arch}"
      rm_r node_modules/"node-pty/prebuilds/darwin-#{other_arch}"
    elsif OS.linux?
      # koffi requires libc++ which is not available in Homebrew Linux;
      # remove all prebuilt native binaries to avoid audit/linkage failures
      rm_r node_modules/"koffi/build"
    end

    # Strip universal binary to native architecture for `clipboard`
    if OS.mac?
      deuniversalize_machos "#{node_modules}/@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kimi --version")
    assert_match "No providers configured", shell_output("#{bin}/kimi provider list")
    assert_match "No model configured", shell_output("#{bin}/kimi --prompt hello 2>&1", 1)
  end
end
