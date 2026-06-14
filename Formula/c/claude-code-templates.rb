class ClaudeCodeTemplates < Formula
  desc "CLI tool for configuring and monitoring Claude Code"
  homepage "https://www.aitmpl.com/agents"
  url "https://registry.npmjs.org/claude-code-templates/-/claude-code-templates-1.29.2.tgz"
  sha256 "ed0d89293d51b7adf19033fb8268b30722afa51a215524aa698890a28bc3055f"
  license "MIT"

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "89ea850049a4b5e93835fee04f8f514e2067abc2d96e78b77b7b5cbf5f9d6a72"
    sha256                               arm64_sequoia: "df4b5909b2960094bf7de860db0026e658c6e8e95dc4bc3b0c929764f0d8485a"
    sha256                               arm64_sonoma:  "68e3dfc642889dd58f4fe14fb28f37e6db35739c6c258ccedd60dc28eb3cb9ad"
    sha256                               sonoma:        "8be670a369dae7c932c89872ff86771546af9a37295dd09a0d9502d3aefc64bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6760692850624d16d3d8e459bb980c302b10c3f1e92ebc56ef37b2412a978b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f23c13041200633a214b50aa243618d0fac55bfb7509d0fc3293cdef9dfd13b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove pre-built binaries which were source-built via script
    rm_r libexec/"lib/node_modules/claude-code-templates/node_modules/bufferutil/prebuilds"
  end

  test do
    # TODO: recover version test in next release
    # assert_match version.to_s, shell_output("#{bin}/cct --version")

    output = shell_output("#{bin}/cct --command testing/generate-tests --yes")
    assert_match "Successfully installed 1 components", output
  end
end
