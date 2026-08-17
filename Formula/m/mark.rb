class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.10.0.tar.gz"
  sha256 "ab44c3b161561998dd3935b2e930b63710d88d840c95babd1abafbbcfdd652f0"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29e6e2dd6fef6501e95f96dab28a07056fda8a56059ac83dce8cd70d0580cc02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29e6e2dd6fef6501e95f96dab28a07056fda8a56059ac83dce8cd70d0580cc02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29e6e2dd6fef6501e95f96dab28a07056fda8a56059ac83dce8cd70d0580cc02"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4d1e0ae98228a47ea0b777b3a97b777feeba9f39ab3ce4f08459f9717c73d50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa6cdc0f1ace3b3b616a1aed194166611f2f3410ede56c44ec3e2c4147311532"
    sha256 cellar: :any,                 x86_64_linux:  "f5d4e7b4c1756393ac093d2179c51045cd7f76c94e60f70d5c47f1db459a3e8a"
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
