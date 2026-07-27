class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.7.0.tar.gz"
  sha256 "a572184aa7f1d8648a3e1d4323df1fe99f84c498f5fbe7ae08a31113b9298fc6"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fec2d0fc3d23b56c563153c6225a4351a01fa18da869fd2fa91202a58df6e2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fec2d0fc3d23b56c563153c6225a4351a01fa18da869fd2fa91202a58df6e2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fec2d0fc3d23b56c563153c6225a4351a01fa18da869fd2fa91202a58df6e2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cbfda67640595e5cb165be8145183f4df71a68b723981dcca2910f48ebd5454"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "611d6070983941cf56ad874cbf7630e63be9dc4907b5baad9abd448d15dbf5b2"
    sha256 cellar: :any,                 x86_64_linux:  "68ae45e1307402b241a245bb19a6d729276dac7fafc8fbeced2bdbd631e32603"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/mark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    output = shell_output("#{bin}/mark --config nonexistent.yaml sync 2>&1", 1)
    assert_match "confluence password should be specified", output
  end
end
