class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-12.0.2.tgz"
  sha256 "e06a54efbaf46b3c2e4f438699361f2e3034fd84ce240b54216fbe4b0bf41d73"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "79a21943f516c390314d32c39aba21d241974fd22500bdb7a706fe3b54a8a5e3"
    sha256 cellar: :any, arm64_sequoia: "5fc08a61624f4c07bc97cabaab4ab16c154f9d6b337f95681712cf972770745a"
    sha256 cellar: :any, arm64_sonoma:  "9ac7112aa41de55a3dc05110aff790ef9d4a891dbc5030b2667a92755bfccdea"
    sha256 cellar: :any, sonoma:        "a5f8efcde9c5d7389a2d0decc9f92abbb61fc508000c3f9bddd834bd5bb27545"
    sha256 cellar: :any, arm64_linux:   "3fcdb45949f22e880b807869f6c3bfb30621b704ff52d4723e7dbf171328e7ea"
    sha256 cellar: :any, x86_64_linux:  "9665815a172a69200dd793b7d0012cd47d9e1b660a026f4bbd700bcebe3e0aab"
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
