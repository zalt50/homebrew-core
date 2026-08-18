class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.12.0.tar.gz"
  sha256 "473b21a29017c1f10a93b2dae64c8d715630736133fef9119290c6497d63ad77"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2197b8694595d75a41d9e5b8b3c1ea3f95af4a3909822c958d074be181a03e4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2197b8694595d75a41d9e5b8b3c1ea3f95af4a3909822c958d074be181a03e4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2197b8694595d75a41d9e5b8b3c1ea3f95af4a3909822c958d074be181a03e4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "11fb176cd3bafc21e9af84b701ce5223e3600f6e7d3148bad2a642ae9654e09b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2408ba46e6cfb001920e49f89d46b6d959ac84edaa63e6b1238107021220f528"
    sha256 cellar: :any,                 x86_64_linux:  "0b09d3158dc96136db95f2d0caa4069fd3024f3defe9f83b28457a344590471f"
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
