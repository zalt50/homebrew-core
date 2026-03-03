class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.15.3.tgz"
  sha256 "7725b50af7bd14bbb158cd85c5a7a158a1d9c8200fffdcfd22e2264c4a66b2c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ad5fa0a3c1fdd7a509ab185dce3e2bef45bb3ffdc31bef957e7702a1e089b364"
    sha256 cellar: :any,                 arm64_sequoia: "8971224496d92fb9b6c7723483dbc45bf016e39b22f52b0b04112050272c01b1"
    sha256 cellar: :any,                 arm64_sonoma:  "8971224496d92fb9b6c7723483dbc45bf016e39b22f52b0b04112050272c01b1"
    sha256 cellar: :any,                 sonoma:        "65ea0c058e0dc69843db09e8a3393bf3b7b7cf143d6edbb3ba72d02a477ef607"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fed16e9c1149543a8a1dc12a53f8c083c3ed37ac6873c8c9ead30e20ee05554f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bef4daabbe348189568e4637b5678454ffb0fa2735e2dcd9ed53df08dd6140ad"
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
