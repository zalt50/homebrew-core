class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.168.tgz"
  sha256 "56404ef8e4dcb8894487ddb2e6e40b71ead48be96d39602ba922564f9bb9ff32"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e748326dc324d4a2e57222894bff63d255b53a49d2ae186563254b1423bc42a2"
    sha256                               arm64_sequoia: "e748326dc324d4a2e57222894bff63d255b53a49d2ae186563254b1423bc42a2"
    sha256                               arm64_sonoma:  "e748326dc324d4a2e57222894bff63d255b53a49d2ae186563254b1423bc42a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "99c4f20b0f80e6dfb50aba3ca2d29b8e6167ca103c6c81150ad3399b66ea1eaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36aba3ea665aeb6148b62b396dfd4a4625dc8cbe4e55d0453855663ba6f3cd34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "434c75b104a7d4198221a2a9ff039ac6170761f6812289cd2e913b74bede9008"
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
