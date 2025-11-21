class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.88.tgz"
  sha256 "815323da8b38915b113eb7d05e38753efb14f0e47ea71ae6d81a425bcfcf6302"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "abb7e620ba85597e666796d0a20030cb1a5a6a1700de4c30aa30b6489d27902b"
    sha256                               arm64_sequoia: "abb7e620ba85597e666796d0a20030cb1a5a6a1700de4c30aa30b6489d27902b"
    sha256                               arm64_sonoma:  "abb7e620ba85597e666796d0a20030cb1a5a6a1700de4c30aa30b6489d27902b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffb802023679896b301841484af69c7be4a4a38d67d577f47f5c1446267feef8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d470fada424be0430b9ba115db08adf7803ed7a461c49dbc6dfc180e53bb865f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df2fbf304dc03bbcb34110fc50e267c17fa6564d27e5ea404a9cce9755186a3a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
