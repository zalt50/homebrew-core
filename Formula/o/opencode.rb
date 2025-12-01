class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.124.tgz"
  sha256 "f0717cfca27eb1d2a7d43960604216e275337e18f4fb94913d3ded95104a4252"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "58d8e4efe9aa7875aecc9ccb52ccd3626635b268bfcb73fb1f008a80100628e4"
    sha256                               arm64_sequoia: "58d8e4efe9aa7875aecc9ccb52ccd3626635b268bfcb73fb1f008a80100628e4"
    sha256                               arm64_sonoma:  "58d8e4efe9aa7875aecc9ccb52ccd3626635b268bfcb73fb1f008a80100628e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "46e636e801f2de09c4fba9c0157926890ff45a8c212f128d3d9f5186b362adb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c059c390f517d96969eede9f61aa0bb27366cbbe1e593c5a89d8f24f55476ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69ab8d65b31f89233a2eca616b0b81ade3550ea9b73726c565e2b9e3ddbd5e82"
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
