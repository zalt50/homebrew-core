class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-11.8.0.tgz"
  sha256 "be3df8e831a6353deef989b0231a5e88d807c63b76db288c713269b3dcfaec31"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4ef7adc786e444c6cbf98b4b5cefaeee309ad10ed3fd738192c68f2f65961058"
    sha256 cellar: :any, arm64_sequoia: "88562a7093a779c0fefc4a91f8e0341ff1f7448a9343a80e384f7c3bf52e9466"
    sha256 cellar: :any, arm64_sonoma:  "99b0631abbf09eac03d80461fda7bfa2399cf0169a89e99b358d879fb0c31021"
    sha256 cellar: :any, sonoma:        "4dbf302fe9972a60f5fe07db1aed054f36a7b141966a740b45aba4c55983a1c2"
    sha256 cellar: :any, arm64_linux:   "f008063f453bd78d870a8b3929a6b12f36980505e1237f9cc7d35085ecb4342a"
    sha256 cellar: :any, x86_64_linux:  "42187c76d3feccf25b6e6f4285eace07667c8f0aa2cd8a6993d202f2f46f7b4a"
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
