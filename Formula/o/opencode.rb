class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.81.tgz"
  sha256 "4198e9a7c84a103cf843904dae7dace4f34e4ecfeb540d79c335bcf339680d92"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "f81f90d465d6a6420c7349de6168ea242320986cbe97112c2432034b3506d0e7"
    sha256                               arm64_sequoia: "f81f90d465d6a6420c7349de6168ea242320986cbe97112c2432034b3506d0e7"
    sha256                               arm64_sonoma:  "f81f90d465d6a6420c7349de6168ea242320986cbe97112c2432034b3506d0e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a3a51227823c3980738868194b37df06156f602d59f25f7ab95134bffbbad74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fcb03f2e74a195129666611ea0a5d1d0a87f8882259cf3c7363d3644ab1c651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e1c1cf94f6ff1f5a3550307dde1942afaa4870f673b043d752636d52c6a4c0a"
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
