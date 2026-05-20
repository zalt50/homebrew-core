class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.15.5.tgz"
  sha256 "a277fd68112e5392ea8630a40ba0694327310984d9909929bd7aa0de587ff55d"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    sha256                               arm64_tahoe:   "4070b9426f65906c1bca9898dd58939cf935c1be5d08c167c377655880598176"
    sha256                               arm64_sequoia: "4070b9426f65906c1bca9898dd58939cf935c1be5d08c167c377655880598176"
    sha256                               arm64_sonoma:  "4070b9426f65906c1bca9898dd58939cf935c1be5d08c167c377655880598176"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9ff7b1989cfbcf7cfdc884a711d9a328ff2471bc4f2725e7ae4d9bbbf535a70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc5f7d275dffb03f83127bb0847e7329f10893242f8105f3cf3535df44730ae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "459c7cda440eb2145711a56a5a99561482df345b9d3f4d125e94e3d31ffb55f0"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
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
