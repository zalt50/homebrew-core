class HtmlToMarkdown < Formula
  desc "Transforms HTML (even entire websites) into clean, readable Markdown"
  homepage "https://html-to-markdown.com"
  url "https://github.com/JohannesKaufmann/html-to-markdown/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "da15e96199bea9ed610996548f43eae19059edc364ac08baf107c0777fefbea5"
  license "MIT"
  head "https://github.com/JohannesKaufmann/html-to-markdown.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"html2markdown"), "./cli/html2markdown"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/html2markdown --version")

    output = shell_output("echo \"<strong>important</strong>\" | #{bin}/html2markdown")
    assert_match "**important**", output
  end
end
