class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.20.0.tgz"
  sha256 "b7a03262f0a3c4a66749afd5daa1e0648cdf208339001f249425c8056459e200"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9990fd83f3eb4e3946d3c5fc1ad13e3a05ed6e6874cea2e1333b7142d69cfaad"
    sha256 cellar: :any, arm64_tahoe:       "4e018ee5fdf9138b7b0650dfe7dfae8b6f61327458a4a24b95d2502e462fa0a5"
    sha256 cellar: :any, arm64_sequoia:     "eb330a0f273e471d0f98ec8e7d2004e02001f2e646195c84efaa5d35483acef4"
    sha256 cellar: :any, arm64_linux:       "5e14c5776832d40612894c8548572446e047c6651505f06229725582d2b76971"
    sha256 cellar: :any, x86_64_linux:      "b54d06475d7a83b64878b48424848c73ed89174a129de4c3f6049f3000d36422"
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

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".agents/state/memories/orchestrator-session.md"
    assert_path_exists testpath/".agents/state/memories/task-board.md"
  end
end
