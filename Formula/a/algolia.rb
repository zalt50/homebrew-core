class Algolia < Formula
  desc "Command-line tool to manage Algolia applications, accounts, and search resources"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://github.com/algolia/cli/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "eac19d1691e42b912c8bd7e148eba6305b7f7c6e61e6a03f398644552143bdd7"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bff70108a78ce96ed337122f3457e479d13e3f52a885a9c4bbf4e477f168ab6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bff70108a78ce96ed337122f3457e479d13e3f52a885a9c4bbf4e477f168ab6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bff70108a78ce96ed337122f3457e479d13e3f52a885a9c4bbf4e477f168ab6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c81318c369747e290952cf983c3bc33036ad03f6308c7a73497eaf446931e74a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da06fe935b1de15b255f61ab7c5a7f460a18f77b0d561685d78b6fef9a0d3042"
    sha256 cellar: :any,                 x86_64_linux:  "a7f7c3dddc7e93541818dbc3bb547c7ceb74e062be76c8e0609ec9584b38c8e7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/algolia/cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/algolia"

    generate_completions_from_executable(bin/"algolia", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/algolia --version")

    output = shell_output("#{bin}/algolia apikeys list 2>&1", 4)
    assert_match "you have not configured your Application ID yet", output
  end
end
