class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.1.tgz"
  sha256 "9979a8b73deddcd6c60f98c8c9f3b98263563d33150f6fd60289fba6f43f4ccf"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e4472e08635132a747ba0a2ab72df86cecfa9da6567f2a3ca6072a9b1b179374"
    sha256                               arm64_sequoia: "e4472e08635132a747ba0a2ab72df86cecfa9da6567f2a3ca6072a9b1b179374"
    sha256                               arm64_sonoma:  "e4472e08635132a747ba0a2ab72df86cecfa9da6567f2a3ca6072a9b1b179374"
    sha256 cellar: :any_skip_relocation, sonoma:        "68bf33c661370b71b1a7797f0e9e3eddbcbc1815939ec83b9b559db7dd11215c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27535f3905ead3ca89921b24c813906f21f2eaf9be95a7a547cdfb216f5bc656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a78d57172a41dcd5c76f2c72a6e38736fe4338261b48094d3d2f24b47feb192a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
