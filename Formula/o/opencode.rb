class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.80.tgz"
  sha256 "d39a129f87d8411712cefba8fed98bec00df1d6c16a12551ca21f7ce45991700"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "c8112da47685b32e411cfbfa478c546c7afa86b9f52ed0326c5a93019faa67e7"
    sha256                               arm64_sequoia: "c8112da47685b32e411cfbfa478c546c7afa86b9f52ed0326c5a93019faa67e7"
    sha256                               arm64_sonoma:  "c8112da47685b32e411cfbfa478c546c7afa86b9f52ed0326c5a93019faa67e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "29f2b260cf8e6fefd41ea7e5c2efdf1e9a59430daffb11229f68d3d4c2525a8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8efff2b11c92c51eed1ab6227b5436b29429b2eaab0612104fa6b4eef9abbc3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4fbc2e690a3fc000a2f5960c98b409667f9849bc264e2b804e4f9cf43dbd352"
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
