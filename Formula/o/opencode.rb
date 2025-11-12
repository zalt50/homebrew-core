class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.60.tgz"
  sha256 "d5030ac19449b685a047fcda044f03d6a7a0bcac1373f10942a53679bc196815"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e42b2f4fbb23612b73a27fc169966b11ed5056ca1a05ff174ff19d54687f9429"
    sha256                               arm64_sequoia: "e42b2f4fbb23612b73a27fc169966b11ed5056ca1a05ff174ff19d54687f9429"
    sha256                               arm64_sonoma:  "e42b2f4fbb23612b73a27fc169966b11ed5056ca1a05ff174ff19d54687f9429"
    sha256 cellar: :any_skip_relocation, sonoma:        "f669169cb6cd49379802c055755cac1190b8909812dce9217efb02e4a170c8df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b57231a3a2990bfc55c6e53e7f7caffd0dea2615782cc4d0cd8fd33bd912162d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b93a779de78e7f7d7830be3eebd151c335f6e1c41e54c92034fc32282b4bde78"
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
