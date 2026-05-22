class GitPkgs < Formula
  desc "Track package dependencies across git history"
  homepage "https://github.com/git-pkgs/git-pkgs"
  url "https://github.com/git-pkgs/git-pkgs/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "1d7941470e80f6a416431d62cb10d3f6cb50df53d57e782806990457baac1c6e"
  license "MIT"
  head "https://github.com/git-pkgs/git-pkgs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c854211300ceb517ff5e1a2ebb4b9fd873d8dbde43ac0fbf8f3b8cbed52f7ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c854211300ceb517ff5e1a2ebb4b9fd873d8dbde43ac0fbf8f3b8cbed52f7ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c854211300ceb517ff5e1a2ebb4b9fd873d8dbde43ac0fbf8f3b8cbed52f7ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "b604f42f062006a4e4036b9444a0ecea8d962511f57a78f4e2de23b28a74d317"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bda9ca6aeb41ae6baf585a7f92d14f8c8f331bfdaa9745a9abac6cc6ea7fe44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26a0eb527dc6893c70cfe1da16407c58384218733ab4b46f84bffb50a504adbb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-pkgs/git-pkgs/cmd.version=#{version}
      -X github.com/git-pkgs/git-pkgs/cmd.commit=HEAD
      -X github.com/git-pkgs/git-pkgs/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    system "go", "run", "scripts/generate-man/main.go"
    man1.install Dir["man/*.1"]

    generate_completions_from_executable(bin/"git-pkgs", "completion")
  end

  test do
    system "git", "init"
    File.write("package.json", '{"dependencies":{"lodash":"^4.17.21"}}')
    system bin/"git-pkgs", "diff-file", "package.json", "package.json"
    assert_match version.to_s, shell_output("#{bin/"git-pkgs"} --version")
  end
end
