class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.74.tgz"
  sha256 "129b672e9ea1632bc9be12343006ec4ce93a629dc965641771f1b35eeebbd5f8"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "072ee9058cdc6f788284276455c68398ff95629285ffa5b799122d6a903aebef"
    sha256                               arm64_sequoia: "072ee9058cdc6f788284276455c68398ff95629285ffa5b799122d6a903aebef"
    sha256                               arm64_sonoma:  "072ee9058cdc6f788284276455c68398ff95629285ffa5b799122d6a903aebef"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac28950b6f5452213cc934ddd1c013fd692d707bf7aeb8808278bcb211bde14d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd390a56f98cf1e25044874808985db88fdb4a6337d6536f4e9d73fcdae3ab82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ef7351943f75b4f2a1e51b8e4509fd17745e60d9bcb94442e03fd0018de6589"
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
