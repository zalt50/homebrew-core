class Treehouse < Formula
  desc "Manage worktrees without managing worktrees"
  homepage "https://github.com/kunchenguid/treehouse"
  url "https://github.com/kunchenguid/treehouse/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "6991409415221ea7052c21c357c10e24aab2b81d76f7ad7575f657579c28943c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e57948db6c2c52c784cb79bb010f825b1278bbe6d63d4c234d531daf17816674"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7542564c3a1a600c4d9b7557cbd3f3aa5eac3a6f51fcb0408c646e74207ecdf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f4da9900b9334e092742ce176fc0b9e248b5af0f83dfee9913ce972289e9285"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc9d3c5a634efdbcf84c24f3be0eb35e0a77026658cabfbe8816f8dfd8b75b98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "359084db3e6bbfdce1721f07dbe0b7a3c4ef55a5a062cce3eaec78f2f81bec56"
    sha256 cellar: :any,                 x86_64_linux:  "b96dfdc91ea47a83e62aaa8c2d4f15c3cba0fbb772abe83df5cc3cf96555118f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    system "git", "init", "--quiet"
    system bin/"treehouse", "init"
    assert_path_exists testpath/"treehouse.toml"
    assert_match "max_trees", (testpath/"treehouse.toml").read
  end
end
