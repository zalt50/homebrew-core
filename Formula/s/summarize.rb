class Summarize < Formula
  desc "Multi-modal AI tool to extract and summarize content"
  homepage "https://summarize.sh"
  url "https://registry.npmjs.org/@steipete/summarize/-/summarize-0.21.4.tgz"
  sha256 "56b29662536b9ba7a0f515ba746e2b88c4985cd025725b2ff22c2710858ebf3b"
  license "MIT"
  head "https://github.com/steipete/summarize.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "defca2075637e07ecaabe53c3cfe7e0125b397007988e0dc3f13715b704664a5"
  end

  depends_on "ffmpeg"
  depends_on "node"
  depends_on "tesseract"
  depends_on "yt-dlp"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/summarize --version")

    output = pipe_output("#{bin}/summarize - 2>&1", "Hello from Homebrew test.")
    assert_match "Hello from Homebrew test.", output
  end
end
