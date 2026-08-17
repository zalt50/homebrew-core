class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.10.0.tar.gz"
  sha256 "ab44c3b161561998dd3935b2e930b63710d88d840c95babd1abafbbcfdd652f0"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c18b634cbb80a92091040c8cc074825cfc5bab53e2df722e2b13fba5588456ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c18b634cbb80a92091040c8cc074825cfc5bab53e2df722e2b13fba5588456ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c18b634cbb80a92091040c8cc074825cfc5bab53e2df722e2b13fba5588456ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca5bb6bcfc9ef4f8225d740a161021c657dc7b4be12649dba9e45c522a271c99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0ad9fe4d50eaa98ab973c214b382fa37782dea0d762fc31f744104970e34fe4"
    sha256 cellar: :any,                 x86_64_linux:  "826b1c212be6a06f66f8481d4eebefdec7438b5fde91057b6bf126ab8e088825"
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
