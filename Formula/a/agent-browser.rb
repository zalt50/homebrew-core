class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.15.3.tgz"
  sha256 "7725b50af7bd14bbb158cd85c5a7a158a1d9c8200fffdcfd22e2264c4a66b2c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e2760bccfa9c637fb7b4a79a265c9906632e44fc2186bc827d6ed01d86f48377"
    sha256 cellar: :any,                 arm64_sequoia: "998a767957893149995609487d429462c5de0fadd004c8886b451b92c8848731"
    sha256 cellar: :any,                 arm64_sonoma:  "998a767957893149995609487d429462c5de0fadd004c8886b451b92c8848731"
    sha256 cellar: :any,                 sonoma:        "ddbaf3637b9aa00df5fa2390db72f188115e314311272c5f97c2cc1c942322e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "386afab800e0ea72e8aeaacf73ed496b4dc5751135d1e56493bf6d9eb74e3893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ea8c77c5a53f2d9459b84451ca29d78b07b2bd5ad296485d5e0a3fc3120bc7d"
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
