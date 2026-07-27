class GitPagesCli < Formula
  desc "Tool for publishing a site to a git-pages server"
  homepage "https://codeberg.org/git-pages/git-pages-cli"
  url "https://codeberg.org/git-pages/git-pages-cli/releases/download/v1.10.1/git-pages-cli-src.zip"
  sha256 "a4b23a4ef54111b160e9dc749d288ba96645282f78f355bbf28d2b48a1c6a664"
  license "0BSD"
  head "https://codeberg.org/git-pages/git-pages-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "027850d3d1a6d2d0fb2a9b658efaeb5577ad1fe93a56b9558ba910eae6d5f8a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "027850d3d1a6d2d0fb2a9b658efaeb5577ad1fe93a56b9558ba910eae6d5f8a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "027850d3d1a6d2d0fb2a9b658efaeb5577ad1fe93a56b9558ba910eae6d5f8a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a540558e0340a91c16949536dd6520cf92670ab6d55cd71fdbb2bc918956b91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f47dd3b406b508137a3705575398af41aec20a0ce6137d4f7f77eb3a026d44c"
    sha256 cellar: :any,                 x86_64_linux:  "38fccdc623ebc1c9fc0802983ec9664479fd9cbe6243a9bdf5ea6dca3956adc4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.versionOverride=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-pages-cli --version")

    output = shell_output("#{bin}/git-pages-cli https://example.org --challenge 2>&1")
    assert_match "_git-pages-challenge.example.org", output
  end
end
