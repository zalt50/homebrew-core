class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.99.tgz"
  sha256 "dc3b8b0e4419dd9e42053504be3d4b7e1ec04773b9c824165346b424df0ec575"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b793f0fec83924b3578d4fa1da64a706c40cfceab73638789113c50b80cc3990"
    sha256                               arm64_sequoia: "b793f0fec83924b3578d4fa1da64a706c40cfceab73638789113c50b80cc3990"
    sha256                               arm64_sonoma:  "b793f0fec83924b3578d4fa1da64a706c40cfceab73638789113c50b80cc3990"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd881c508f167be22d0ad73e7031cb8fb9e4f831bc9f26e7ebd342e1edc1ba96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfdb1c91c6dc0f0c931ac1f90a7b2a60926b196b5eae710fd9f4f16b25a4233a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8142a83f7c0e5e27e68e533f20c16856abde92a9a0c22432788a168ee0cdd0c4"
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
