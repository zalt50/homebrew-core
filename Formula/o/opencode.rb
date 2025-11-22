class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.104.tgz"
  sha256 "a0a3d1283a4004e8f89ea45b863e01d49c4e24ded53a8b27a87471337d51ccf4"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "cceaa09b184e8f97378e0f0a6e1beb865b09723259d7701d68db412ff6f16176"
    sha256                               arm64_sequoia: "cceaa09b184e8f97378e0f0a6e1beb865b09723259d7701d68db412ff6f16176"
    sha256                               arm64_sonoma:  "cceaa09b184e8f97378e0f0a6e1beb865b09723259d7701d68db412ff6f16176"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d14a591d90e36018e5dc1637d18f812d8437e094f883ad826f45222fabd7d6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c33af7e3bd0d30523a5909344359123e699464d24cdb9e2e53ba1d9d03692d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2864ba74c393801f8ef8ab69b09e86a86b5aa5d642ca8d9963e06d111e7a210"
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
