class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.1.20.tgz"
  sha256 "5b66722ab09c46ab18613bceb1cd0c3953c0bdab146f43db9f6ae43e11c2a227"
  license "MIT"

  livecheck do
    throttle 10
  end

  bottle do
    sha256                               arm64_tahoe:   "8cb70ad775d5b40e87f5e66cd7fc37d4a725296a03d25974af193d94f0316ca4"
    sha256                               arm64_sequoia: "8cb70ad775d5b40e87f5e66cd7fc37d4a725296a03d25974af193d94f0316ca4"
    sha256                               arm64_sonoma:  "8cb70ad775d5b40e87f5e66cd7fc37d4a725296a03d25974af193d94f0316ca4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1561e8e22102c25578e53920421da96519fe76e4f94133bf8be37617aee1ad50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30716a56d14fc11c615d10361c2bbcd481aaa99b6e902887e16841d58e8adf65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11b89fb3bf0616c349e8323b3a68933ba7b06121f0e8db8f41284c2f24677e90"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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
