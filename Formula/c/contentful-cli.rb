class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.10.0.tgz"
  sha256 "c18cad715a81d1d61aaed1da08355813ab2239c21e51feb8c22763c8503a0db6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b47c2cca69ffed0a4b4ca27e8671e411b1f7df37eb856b51bedc00afddaaef02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b47c2cca69ffed0a4b4ca27e8671e411b1f7df37eb856b51bedc00afddaaef02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b47c2cca69ffed0a4b4ca27e8671e411b1f7df37eb856b51bedc00afddaaef02"
    sha256 cellar: :any_skip_relocation, sonoma:        "b47c2cca69ffed0a4b4ca27e8671e411b1f7df37eb856b51bedc00afddaaef02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b47c2cca69ffed0a4b4ca27e8671e411b1f7df37eb856b51bedc00afddaaef02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee916dcc28ce5414e501f8b690f45d0526bf323b9d08496b749d294409ab6c77"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
