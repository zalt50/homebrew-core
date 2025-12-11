class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.147.tgz"
  sha256 "e0f966b4fa45b5b626425afee41b96c8a8683fe68d549c4549d5a67b92b8090c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "ca2a1837724fa3dda40dec893b12512a0e6f860784db668ca8bffc5fd0578f40"
    sha256                               arm64_sequoia: "ca2a1837724fa3dda40dec893b12512a0e6f860784db668ca8bffc5fd0578f40"
    sha256                               arm64_sonoma:  "ca2a1837724fa3dda40dec893b12512a0e6f860784db668ca8bffc5fd0578f40"
    sha256 cellar: :any_skip_relocation, sonoma:        "14c040c0f01912bab217c2596ad95a0e68833bed9af1cc19f4d88eae7e21dc46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "678b67cde2b612a103a8a44767ca4a1fa60b1c1aa88d74a71df0ac75abff6074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5be39859a186dd7132c57acf882e7bb9a4525c3d592426b8011a77e99929acba"
  end

  depends_on "node"
  depends_on "ripgrep"

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
