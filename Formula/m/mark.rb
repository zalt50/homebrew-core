class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.20.3.tar.gz"
  sha256 "046efc5a94135a16d661541cc8650fe173fd63a15b03a6f2c83ec29f0b9e4f9e"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3109e13108a234db736ce6027570ee91f8effc950bee103e8633b49366ca6dbc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3109e13108a234db736ce6027570ee91f8effc950bee103e8633b49366ca6dbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3109e13108a234db736ce6027570ee91f8effc950bee103e8633b49366ca6dbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "231fea70e656357109c93483976c23f4de192dbea1ef8a74ab0ccca632e41371"
    sha256 cellar: :any,                 x86_64_linux:      "82b9507ad79a7cf2904bad53441804ab48df3827793698452ee20bec50238a61"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
    assert_match "confluence base URL should be specified", output
  end
end
