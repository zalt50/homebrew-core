class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.159.tgz"
  sha256 "ad32d223aa3cef08be9c7a41e995b006851c90d99284bd79c309249881a87e30"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a70e68db90cf35357846fb53f9034f75e551d9cd7bb8f5114e2cac202e0efd43"
    sha256                               arm64_sequoia: "a70e68db90cf35357846fb53f9034f75e551d9cd7bb8f5114e2cac202e0efd43"
    sha256                               arm64_sonoma:  "a70e68db90cf35357846fb53f9034f75e551d9cd7bb8f5114e2cac202e0efd43"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d6dd29100a656487aa600d65cf3d4524f983174223aae6cb01691b39e5533dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a1d2fda4ad8321051f77a22537338aa0bad6f47f87e550e899f55b5eacfdaab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d312368f7d5a68cd670c0f074e49d825409777e2927ef9da1ea283fece6703f2"
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
