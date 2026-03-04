class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.16.1.tgz"
  sha256 "011b27de09b41f617d85b49e222ac0c574f9dce2a30cce9d3d4190ec42115fd4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "18b9f135e029775bda4dd87f1de6d389bb439d58ab9db60a4ffa13e02d902337"
    sha256 cellar: :any,                 arm64_sequoia: "338609262106a5d0bbaf39020278566e86e028b7cccaf0620a7dc9e5ba4e4f47"
    sha256 cellar: :any,                 arm64_sonoma:  "338609262106a5d0bbaf39020278566e86e028b7cccaf0620a7dc9e5ba4e4f47"
    sha256 cellar: :any,                 sonoma:        "3e6ae82b28678b733492ceab2d0717e938ecc638b1b1183b331ab8e4d9b6432f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e13701f292f14a565a756a8e90030f2f01a87baa47cf9f016dfe44923d8388a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d263e7bd34919196b41dabc37b31bc2738bfe44b0fad7d0f32db3d208b18713"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove non-native platform binaries and make native binary executable
    node_modules = libexec/"lib/node_modules/agent-browser"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    (node_modules/"bin").glob("agent-browser-*").each do |f|
      if f.basename.to_s == "agent-browser-#{os}-#{arch}"
        f.chmod 0755
      else
        rm f
      end
    end

    # Remove non-native prebuilds from dependencies
    node_modules.glob("node_modules/*/prebuilds/*").each do |prebuild_dir|
      rm_r(prebuild_dir) if prebuild_dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  def caveats
    <<~EOS
      To complete the installation, run:
        agent-browser install
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agent-browser --version")

    # Verify session list subcommand works without a browser daemon
    assert_match "No active sessions", shell_output("#{bin}/agent-browser session list")

    # Verify CLI validates commands and rejects unknown ones
    output = shell_output("#{bin}/agent-browser nonexistentcommand 2>&1", 1)
    assert_match "Unknown command", output
  end
end
