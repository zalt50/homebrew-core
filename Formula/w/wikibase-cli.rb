class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-19.2.1.tgz"
  sha256 "012cbb326d9a6d2a7a167af384c518987eb9b076ed104008b415b366e9ece847"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fcf11b3dd4b724f6e6885c2050927e6f5913c76b165fd605582a94e2722c2bfb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    config_file = testpath/".wikibase-cli.json"
    config_file.write "{\"instance\":\"https://www.wikidata.org\"}"

    ENV["WB_CONFIG"] = config_file

    assert_equal "human", shell_output("#{bin}/wd label Q5 --lang en").strip

    assert_match version.to_s, shell_output("#{bin}/wd --version")
  end
end
