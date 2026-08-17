class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.11.1.tar.gz"
  sha256 "bddf30a247ef3e8911c6cad5b0d1b63e0b8c16afd35dcf6de8fc1ec6768922e2"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9901e2e4349d0cf2fd8da996e304fd3c94b9c7546c71a51320da2e4a945f15eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9901e2e4349d0cf2fd8da996e304fd3c94b9c7546c71a51320da2e4a945f15eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9901e2e4349d0cf2fd8da996e304fd3c94b9c7546c71a51320da2e4a945f15eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa6bf80b6ad41aaee6b8157d74ae5d4e50f46faab112e1987e327b469a546097"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93e8be6d5a041e18d95c94c7bb53ffc59bbf2d42d32b96ca11a522b1c239daf9"
    sha256 cellar: :any,                 x86_64_linux:  "2ec4eec6d86e82f1c15367edaa5b147d4494df35b578a15dd4f76b8b7984f99b"
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
