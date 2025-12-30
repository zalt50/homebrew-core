class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.212.tgz"
  sha256 "a1496805c1e8979b17a57ee1dc465edc38ea528e1f4579b4483cb00688a38167"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a696c95cedf5666f303cffcbce4f1ab61ca1a48871e0a17e6ff5e23db27a340c"
    sha256                               arm64_sequoia: "a696c95cedf5666f303cffcbce4f1ab61ca1a48871e0a17e6ff5e23db27a340c"
    sha256                               arm64_sonoma:  "a696c95cedf5666f303cffcbce4f1ab61ca1a48871e0a17e6ff5e23db27a340c"
    sha256 cellar: :any_skip_relocation, sonoma:        "86b56d5048cf357b467b5c242ed5e8a77a6be7d8293b0977578ea1fd5768e052"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1edb6dbcde4cc04358cde706c32b6ee3a926e5e083a294194866e0404618b1e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3087ac669ff957ee0894b4ba859bc34e0664f3d602291deb0bad96f151347b7d"
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
