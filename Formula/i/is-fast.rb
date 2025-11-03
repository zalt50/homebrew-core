class IsFast < Formula
  desc "Check the internet as fast as possible"
  homepage "https://github.com/Magic-JD/is-fast"
  url "https://github.com/Magic-JD/is-fast/archive/refs/tags/v0.17.4.tar.gz"
  sha256 "70e56423ecb2f890e68a92e8a15b65d7619521df2b702cd153af865d3abe1216"
  license "MIT"
  head "https://github.com/Magic-JD/is-fast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14711b9c8ae69321ee1b81399c3c64647b48ba7218d77fed36bffa1478fa6f73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e81b62dd87d0e533972f4a6701e84cddace55382ea4ebafbafce565873a1e545"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fdd7bd18b3385f5d6845aef15df2598dcc1db2010d149a8cb1062aa0be6c555"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a16cd06f533b8b4d664bf10544f7fcefbac517809daf35017b896dd3b9ceefc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5abd6b2dc7895c20eb444f1f93dd80d766f83516213c5a35bacc8c5c4cd804ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4aef171428f9a175b248d0cc8fcfa061cf6b06535758491d2148f34b6c820aa6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "is-fast #{version}", shell_output("#{bin}/is-fast --version")

    (testpath/"test.html").write <<~HTML
      <!DOCTYPE html>
      <html>
        <head><title>Test HTML page</title></head>
        <body>
          <p>Hello Homebrew!</p>
        </body>
      </html>
    HTML

    assert_match "Hello Homebrew!", shell_output("#{bin}/is-fast --piped --file #{testpath}/test.html")
  end
end
