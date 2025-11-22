class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.91.tgz"
  sha256 "34bd0710b84766087f83e92e6c96b1b06bbc64f44416c72e8c9d80fc19379a8c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0001bed495ecc086025a3e9d445e1ae5255cc7356493ea245223d2f8bdffca52"
    sha256                               arm64_sequoia: "0001bed495ecc086025a3e9d445e1ae5255cc7356493ea245223d2f8bdffca52"
    sha256                               arm64_sonoma:  "0001bed495ecc086025a3e9d445e1ae5255cc7356493ea245223d2f8bdffca52"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d4a6f09425e575b262162f998288108ad69e37dd8f63967f206a77464af651e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c1f120cf78fe4f7e6dd18ca50586d87311c6fb460a83360fbdb668177592606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e586fd8b47c149d438ec029f9c108aaa31137c2acd088d7c56bbd9b47c5f7b52"
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
