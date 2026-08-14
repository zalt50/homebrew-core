class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.9.1.tar.gz"
  sha256 "6f6cb46a6e4d45cbceda87395e09fd729d13bada2affa6c8ae74c627f8c6e051"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "343e19ca92d50eaef2cc07a645a3d2921ee1290c2105fabd71aae584f7d89489"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "343e19ca92d50eaef2cc07a645a3d2921ee1290c2105fabd71aae584f7d89489"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "343e19ca92d50eaef2cc07a645a3d2921ee1290c2105fabd71aae584f7d89489"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbbe756e22499c77cee49a945f5dc5c0f33928f37314424718baad2c218e9b1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d6d4d9ce8f93e5889702ad846be47174923c1790a1fa498e877f5ff04c3fd76"
    sha256 cellar: :any,                 x86_64_linux:  "844bab8370ae79bbdcc20092a7074605297f2305a126d9b6c3d4373d40f4ed29"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/mark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    touch testpath/"mark.toml"
    output = shell_output("#{bin}/mark --config mark.toml sync 2>&1", 1)
    assert_match "confluence password should be specified", output
  end
end
