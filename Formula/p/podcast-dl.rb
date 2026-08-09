class PodcastDl < Formula
  desc "CLI for downloading and archiving podcasts"
  homepage "https://github.com/lightpohl/podcast-dl"
  url "https://registry.npmjs.org/podcast-dl/-/podcast-dl-12.0.0.tgz"
  sha256 "fadcddbdc465d7df5d8b4537e2bf307ff61ebc44916959ac5536110bff525d5b"
  license "MIT"
  head "https://github.com/lightpohl/podcast-dl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "85b92f065226d4653459fd250dd82060321ab8172b7aab9e5c8de84c43ca967b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"feed.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <rss version="2.0">
        <channel>
          <title>Homebrew Test Podcast</title>
          <link>https://example.com/podcast</link>
          <description>Fixture for formula testing.</description>
          <item>
            <title>Episode One</title>
            <guid>episode-1</guid>
            <enclosure url="https://example.com/episode.mp3" type="audio/mpeg" length="1"/>
          </item>
        </channel>
      </rss>
    XML

    assert_match "Homebrew Test Podcast", shell_output("#{bin}/podcast-dl --file feed.xml --info")
  end
end
