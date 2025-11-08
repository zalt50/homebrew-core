class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.45.tgz"
  sha256 "3e10692f1048a792056eb4af34b2f6b24373d56e1e9681a359cea639ea921698"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "2f0cc34a6c1119bbf7b0244752fed1b2214918d9a1bb765187c8688362399710"
    sha256                               arm64_sequoia: "2f0cc34a6c1119bbf7b0244752fed1b2214918d9a1bb765187c8688362399710"
    sha256                               arm64_sonoma:  "2f0cc34a6c1119bbf7b0244752fed1b2214918d9a1bb765187c8688362399710"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ee9e199920d84118fcfb5731e97ddae99bcafc94bef8ef343be513907bd87f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e851978a89fcf0f6333e2016d455d19621f1e2a70cd6bfc1432fa5c55b80f63f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd4ded3da71800efed481ae52ddbd3add6cca2f6edee57a4ce0bddf0151f8b5f"
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
