class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.176.tgz"
  sha256 "286fb62973a70a7e67ea77b47ad578712e1821d03b701d342defbec5e796c950"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "68c1902dc4d85eb7b0b1cacc1c92fd93c9148a5626a272f5c275fde4e3ddbca3"
    sha256                               arm64_sequoia: "68c1902dc4d85eb7b0b1cacc1c92fd93c9148a5626a272f5c275fde4e3ddbca3"
    sha256                               arm64_sonoma:  "68c1902dc4d85eb7b0b1cacc1c92fd93c9148a5626a272f5c275fde4e3ddbca3"
    sha256 cellar: :any_skip_relocation, sonoma:        "52826e77408f0f916c74559884618e12012db2d82e9be00113e5993dd6764b4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48366f8fc49a9b93b9fde02bcad8bd78a284129cb7e88f21b5db33a53fa08bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "256a30ebf71ff3d687cf88b11afc322f30edb65eb1faf78e9b7ddb1f07c1c6fa"
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
