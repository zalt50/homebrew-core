class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-19.3.0.tgz"
  sha256 "84cc76f230276451d3450c2562bbb3843b13bc7685d347ef8e16f1d849fd5736"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2b591d4a412d7956eeff45d2164c5616e8331c0b6d786b6ee098d06d92281b82"
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
