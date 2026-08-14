class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-12.1.1.tgz"
  sha256 "ce84e89b2d4e18484a58fd7af5fb7fce150a7fe4ed4bed3223eedf61b121831d"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dbcf85fa1c20710fcc1faaa88a8937045519b0065ba315db792e25097839d083"
    sha256 cellar: :any, arm64_sequoia: "a7018f72f5a530860e643124284b551c1eb0297b981029e3e383e5fcdd79c4fb"
    sha256 cellar: :any, arm64_sonoma:  "9a5b334f0f1bf9b36c59ef4dab85b892fe66cf8137fc2325bfbd72c4f08ef280"
    sha256 cellar: :any, sonoma:        "923f376dc9c378034bf558aca4982721a8678415f5c00874b8d09bee8b2c7d1e"
    sha256 cellar: :any, arm64_linux:   "0671e9ae01b505615ad6240fd2ac158f01912bfa1892ca6ce8527ae55257f956"
    sha256 cellar: :any, x86_64_linux:  "31c5f90e50c3d19ca1f3d5dd6359da67654955e2845c12510d48955a2862ee7e"
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
