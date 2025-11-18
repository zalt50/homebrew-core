class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.76.tgz"
  sha256 "71f47ad78ec74de522e07ebc03dff11ef47ecdf33e822ceacb8ad9bac35a2e63"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "45508d9635fb687e47967d2fe4959bce80409858fddf9baf51e8f77b58ea2895"
    sha256                               arm64_sequoia: "45508d9635fb687e47967d2fe4959bce80409858fddf9baf51e8f77b58ea2895"
    sha256                               arm64_sonoma:  "45508d9635fb687e47967d2fe4959bce80409858fddf9baf51e8f77b58ea2895"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8e5fb2f96dbf203ca3650bf7e616b747ee78573252ba71665b22a882734d951"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cfc629c894771ba3b4ebf2b27316de3804c69178c583df2970e35220823a6bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a35333ae3352dc213702a1b7aedb27f55a404484e9bf5408dfcb00ab23e393e0"
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
