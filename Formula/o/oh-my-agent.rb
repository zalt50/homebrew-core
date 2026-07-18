class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.20.0.tgz"
  sha256 "8209931577a34eebc33d0a43977b7c6e00844b2e8c71d3d200b2f3a39614e7ea"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "89893b07aa842b5a17f6378bf54d08ae0e1e1a05b3be1ae21a85171886c10b4b"
    sha256 cellar: :any, arm64_sequoia: "89893b07aa842b5a17f6378bf54d08ae0e1e1a05b3be1ae21a85171886c10b4b"
    sha256 cellar: :any, arm64_sonoma:  "89893b07aa842b5a17f6378bf54d08ae0e1e1a05b3be1ae21a85171886c10b4b"
    sha256 cellar: :any, sonoma:        "ca5e72116d101ce1824292883fdea867d51c5519e3f5bf4562676fe276266b95"
    sha256 cellar: :any, arm64_linux:   "db2dd87237dddd2d5ed04b31a08950482a585329ed2d9db817f501fa449fdab3"
    sha256 cellar: :any, x86_64_linux:  "d09a125b41ade50b7d84286aab999a83942e34196eb0e6a6fef159505b5cb583"
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
