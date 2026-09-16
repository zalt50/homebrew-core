class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-14.12.0.tgz"
  sha256 "ab6af5a3955fc046fa215e277d69a17e1bda9f0e0d4e554d7269aef9af5d2fab"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "87121ce42fcc0e13ed5db85830b7af8edc1e4fed583d77e96441eddc01487c64"
    sha256 cellar: :any, arm64_tahoe:       "37d2b330e9950172a5a8a93f507ce61388a5ce020d0f6c63f87b040c76148fa8"
    sha256 cellar: :any, arm64_sequoia:     "d67b7ba2787026150540f1da46322d12bb2ffc52939c663539282cb424318e67"
    sha256 cellar: :any, arm64_linux:       "b5700240142e913ac15334a4d563e2dbb75f653259f8da161db2dc67808348e7"
    sha256 cellar: :any, x86_64_linux:      "4280a517a0068e5999316224ec6a6dcc488fc98892d1f6a69268fce2348af1cc"
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
