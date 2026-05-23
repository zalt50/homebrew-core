class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.26.1.tgz"
  sha256 "e43c472f7b5e98395af3ba58aba0373fca032267d56fa8a31d86f7342786dad1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f8ddda9cb228e03ee917dba58db5d41e3d2be760e0beac256ca0b646b896f906"
    sha256 cellar: :any,                 arm64_sequoia: "08b358beebacc12f3264a7a533d45f052634d4ac4538d5491ca70f91a8178fb2"
    sha256 cellar: :any,                 arm64_sonoma:  "08b358beebacc12f3264a7a533d45f052634d4ac4538d5491ca70f91a8178fb2"
    sha256 cellar: :any,                 sonoma:        "e2bb07e631d6caa979063f462d8e552991d45012790600c6854eb02e887c7450"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddbf3928c1b42450c48b27ea50e513ad7fa4a693b0fab48d23a1bfd4994d1d95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6f1e5b8d790a61f5bb572fbad83daaab290d678d4ff3602c778dae9b24b0e9c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@letta-ai/letta-code/node_modules"
    (node_modules/"node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end
