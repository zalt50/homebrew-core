class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-11.10.1.tgz"
  sha256 "8582549f4f3751375d32abfe2bcdad0f3c254bb28a9058266bea4e2706d2f62d"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b68ad05fc3030072aa9a556ca7330add48e9729cc5aa338e9cf4b040a6a406d4"
    sha256 cellar: :any, arm64_sequoia: "909f37a5a7222125a6468dad21220da8328d14fde2627ee1e04c3a6f0551a9c7"
    sha256 cellar: :any, arm64_sonoma:  "3202fe453498d97e3a72b332794ad095f02e290ff612d0557ada974f47c22515"
    sha256 cellar: :any, sonoma:        "ed498b69f3e3d3537b9a3829566a28c96f9533f6cac6f49b8abb4cb04d311057"
    sha256 cellar: :any, arm64_linux:   "25e5411e247760742e769d5a99c81c80a2769fbc9565194a65b71eb322653d75"
    sha256 cellar: :any, x86_64_linux:  "7e860cf85924b6e3bea80c3bac7bbbae7c0fa38d788cf151b254e744dc82fa61"
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
