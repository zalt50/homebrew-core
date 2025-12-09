class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.138.tgz"
  sha256 "8bc11b8988dee5e76bf915d304b17cc032710b079f057c02581930383ff5884c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "640708dc6d3e3a06ada91750d7f981518a784a7876c1110a9085376a1421db36"
    sha256                               arm64_sequoia: "640708dc6d3e3a06ada91750d7f981518a784a7876c1110a9085376a1421db36"
    sha256                               arm64_sonoma:  "640708dc6d3e3a06ada91750d7f981518a784a7876c1110a9085376a1421db36"
    sha256 cellar: :any_skip_relocation, sonoma:        "20960890b312d7f2e6923e2613958416346f6561a4136605e3ab76ce7872a9a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e118f3c94591644277821074d7f5661b4b8e2d3bda79e659a79dff82acc289ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66c98bfdb3a0fab53531a919bb10bf38a5ba82edf32e33e12a7a833fc9fcf3a1"
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
