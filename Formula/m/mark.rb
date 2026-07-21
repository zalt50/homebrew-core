class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.6.0.tar.gz"
  sha256 "2107f8eb7f253e771644e15dcac7c132df5a7b500da69ed9321f1877ea850b4f"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78816b3fba607b50407e6879389568c9d341d1136a6fa581b1e60c1e56983a94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78816b3fba607b50407e6879389568c9d341d1136a6fa581b1e60c1e56983a94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78816b3fba607b50407e6879389568c9d341d1136a6fa581b1e60c1e56983a94"
    sha256 cellar: :any_skip_relocation, sonoma:        "8230c6e4736f79765190ef065e96b29608dbaee3528abf9b6bac90d04176179c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a049e6c4397aeff64a6dead5c32c4c7447293f29a3a8405f7ca5e80445e1bd88"
    sha256 cellar: :any,                 x86_64_linux:  "4a951de8e88cc841b366326966b5459e05cf0adf72e1cda683eeca8fb32d47e6"
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
