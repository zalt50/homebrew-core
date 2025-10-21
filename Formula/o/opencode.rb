class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.15.12.tgz"
  sha256 "fa49ff0ff19a68678c0f8a9c08f9f6977fceaf9400e9c2cf78b634ded2bbd420"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b03277e3cc99673c37acecf9d8d09fda0b45e4c7233c96162bf643da0190cd37"
    sha256                               arm64_sequoia: "b03277e3cc99673c37acecf9d8d09fda0b45e4c7233c96162bf643da0190cd37"
    sha256                               arm64_sonoma:  "b03277e3cc99673c37acecf9d8d09fda0b45e4c7233c96162bf643da0190cd37"
    sha256 cellar: :any_skip_relocation, sonoma:        "a31bab4cd394b1382a90b7f6b528d8bb230c2a048e102defe64cbe0eedf62714"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ce058eb87075df44dc829f0a23b6826ae0dca16caaacec15796b9eb9820a709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0b01da45e15005af1ffddae3578a61eb6fd43d4746bf354ce8b54a98537893a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
