class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.20.2.tgz"
  sha256 "ac8eb0292abdd42eb025353411a888aef38b7ead10ddd52ac6257491e0319d96"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "791de05bce32198fc50b807363167fcfc3d32e2274a4dcd4938463bda65d9f9a"
    sha256 cellar: :any, arm64_sequoia: "791de05bce32198fc50b807363167fcfc3d32e2274a4dcd4938463bda65d9f9a"
    sha256 cellar: :any, arm64_sonoma:  "791de05bce32198fc50b807363167fcfc3d32e2274a4dcd4938463bda65d9f9a"
    sha256 cellar: :any, sonoma:        "456a529d8a7a4ccea84cbc73c9f020836fa4d235530c8aae5ae60865b748a556"
    sha256 cellar: :any, arm64_linux:   "16107f7506f65e78d3ca75ee57dcadf627a1779266074522136cd97fc0ad1ce7"
    sha256 cellar: :any, x86_64_linux:  "72878cad0a24ed863ab3cea078ee8df398b27d5ad38f1aaee410cb402f75d374"
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
