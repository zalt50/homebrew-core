class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.18.0.tgz"
  sha256 "c230764b9fc652a334b22e07c4320fce53550870203626b51e76e9cb54089682"
  license "MIT"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "a269a916f3e55ed5bd6c2a5100a755dc9319f8195b861e8415ee90823b3b7be2"
    sha256                               arm64_sequoia: "a269a916f3e55ed5bd6c2a5100a755dc9319f8195b861e8415ee90823b3b7be2"
    sha256                               arm64_sonoma:  "a269a916f3e55ed5bd6c2a5100a755dc9319f8195b861e8415ee90823b3b7be2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f518026770f397f13b88e76d6ba4721908d56ff59de5759ec3a09e649be0ea63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9c3d0bf917abff88c075fe305d34c23f5c478fd629e2e6bd317c9d01272717b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff5383ce728a5c179b022ba990b99104f6b4ca3e38b55978e68b65746dd11f6c"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end

    generate_completions_from_executable(bin/"opencode", "completion", shell_parameter_format: :none, shells: [:zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
