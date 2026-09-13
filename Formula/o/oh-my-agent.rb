class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-14.8.0.tgz"
  sha256 "a2eb6dfcae6e3ed27ebd789065c5b0ca45da5a792edb8140ebfc1c21e46ec45a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2dc2c6c703eb2057e919fac3ea577c8d5839b09e12f40c699ebf96a179daa910"
    sha256 cellar: :any, arm64_tahoe:       "6f37d737a607702745e18837cf9245d9a667e43527620a9b4a7221bac57bb251"
    sha256 cellar: :any, arm64_sequoia:     "7aed01fc11c77970d67508c79dc9b9e3aa08c0ebf404a704cda0bd05c99ef191"
    sha256 cellar: :any, arm64_linux:       "0640a2245955acf04a6869f07f14a9a8d0ece042290d68d80eb7f791ef56d9cc"
    sha256 cellar: :any, x86_64_linux:      "04d0a01b5652897e264151897dd38a2a113f1991b3913e6d756b20b50af7ae89"
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
