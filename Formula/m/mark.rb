class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.8.9.tar.gz"
  sha256 "701893d85fb6165bfa4cebfbd796f3594f77d6ca3a2cf305e153a3d22465e154"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca804a7806a46b29c3f4d750f029cb7f5f824790fb9f5beff6c51b6f8fc9b84f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca804a7806a46b29c3f4d750f029cb7f5f824790fb9f5beff6c51b6f8fc9b84f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca804a7806a46b29c3f4d750f029cb7f5f824790fb9f5beff6c51b6f8fc9b84f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e881212968be37cd7f72dbfc90b62f52228ea33ac78787c90eecb6b637f04493"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76eda28baf3c7cd0a2a9c8e0c55197ed21a490a563d2914822ebebd52a881ba1"
    sha256 cellar: :any,                 x86_64_linux:  "c7e3936ffe07de2d3a6120dca5a2033a51824c3e90f5740fc052902ae1f595ec"
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
