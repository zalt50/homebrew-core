class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-12.4.3.tgz"
  sha256 "266636830c6f99c5d8a737497f4c9ab5e6cd71bb25b4613970b2eda5a86ecf4e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d1cb539983745339ee016bf71afc0eb8dfb9870e37fbce4fffdf9f614dfc901f"
    sha256 cellar: :any, arm64_sequoia: "1e25e5cf16b1810d32c000d31cc52dcd5fa99280a2d33da473494de0721c99cc"
    sha256 cellar: :any, arm64_sonoma:  "00715a21fd566e4244ce678bf303f9172827d4c350030893987290c453ffac45"
    sha256 cellar: :any, sonoma:        "064195d201765a98d6900c42f0dc0234f34ff713c587139d2f15291acd850c1d"
    sha256 cellar: :any, arm64_linux:   "1f3e4f72302bcbf29b4566ddf0646d94a1bdb7bff5ce284b7d3f0350d471e97c"
    sha256 cellar: :any, x86_64_linux:  "8bc14dbd515a57a66f5d1d9c1aef398572292729f5cce939ef7a17a82f719a4a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-path`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    rm_r(node_modules.glob("better-sqlite3/prebuilds/*"))
    cd(node_modules/"better-sqlite3") { system "npm", "run", "build-release" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".agents/state/memories/orchestrator-session.md"
    assert_path_exists testpath/".agents/state/memories/task-board.md"
  end
end
