class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.98.tgz"
  sha256 "b5e83330788d53de265472e847c8c8e1b967760ceef402634ae060d5a2302aec"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "f58d8cebc404c6e39d95b5d775e198ba8e94b47189dd993d2c19a41d7f4659da"
    sha256                               arm64_sequoia: "f58d8cebc404c6e39d95b5d775e198ba8e94b47189dd993d2c19a41d7f4659da"
    sha256                               arm64_sonoma:  "f58d8cebc404c6e39d95b5d775e198ba8e94b47189dd993d2c19a41d7f4659da"
    sha256 cellar: :any_skip_relocation, sonoma:        "10a0e5eabbf4c9be32b77392e202c9c35d14f68fb792a708aaea21a176eee404"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "becf1ef121fb7c7886c84f9c45afa9122d1a9c594a17d8e7c71b52126b98a781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "989849ef9660a40b273fdb8b2e41d564fc5e555e87678f17859dfada98abe73b"
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
