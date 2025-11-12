class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.61.tgz"
  sha256 "25ae98f7d4f752c7ae60c4d3582b74da88a51a557d1ed99afec4555ad79921c1"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "aec565a861b9541c9e933f611424c3fefbdb103f71e90071041eea2961436e3b"
    sha256                               arm64_sequoia: "aec565a861b9541c9e933f611424c3fefbdb103f71e90071041eea2961436e3b"
    sha256                               arm64_sonoma:  "aec565a861b9541c9e933f611424c3fefbdb103f71e90071041eea2961436e3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b22549010898b1af2fccf4d5a01230f6e645b07ec81804ad4c0ba4056e7afef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b359f79e5df6542d38a25c44f51264bab576d722b80c843dd129d43961a8b1d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2eb7c91e42049dc62f585c68c44d06c75600b92e4590727f8b16dcb0db455d9"
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
