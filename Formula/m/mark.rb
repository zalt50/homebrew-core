class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.8.4.tar.gz"
  sha256 "968bb73af4f490c7512021eb75f9f8440b7655ae3dce2f934de791e64fc26337"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf987d7b53a4a3c9f1f7ac0316101d5dba2599c142583afc17ca6f17564e5c34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf987d7b53a4a3c9f1f7ac0316101d5dba2599c142583afc17ca6f17564e5c34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf987d7b53a4a3c9f1f7ac0316101d5dba2599c142583afc17ca6f17564e5c34"
    sha256 cellar: :any_skip_relocation, sonoma:        "4273c63a21c68d79c8b629a84ffe1bdb65d2e9ffc0b48c73500050e9270cd4f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5de8754464df6017d21a8a31f75f219a02fab9f293c815d48cbdb572c95bd7f"
    sha256 cellar: :any,                 x86_64_linux:  "3d2cbfab3db54c69066082fe5dbc4c2dee58597e84c00d1195abd88ebe8ba0fe"
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
