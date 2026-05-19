class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v2.1.8.tar.gz"
  sha256 "1a96af44d352302cc2c184f9a69249525f15a8fd313b170de1d686603d729811"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ba89c0cf5eb91ee3a8c14c864b6bee2f4cfa34088ef5b80e999247ac62ca8c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ba89c0cf5eb91ee3a8c14c864b6bee2f4cfa34088ef5b80e999247ac62ca8c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ba89c0cf5eb91ee3a8c14c864b6bee2f4cfa34088ef5b80e999247ac62ca8c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b334a69366e59a4d0b97450fad15ca4ecd757d9b65c76f7a9f7abe8700ea5a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "396eb82601e27c94b9b5ae4ed99b7d0462880813695e87d7d9f1e721540d1866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bda49d4da6c84b580b2aa3c0a6287f337ca7d8141efa4f2e3cb37c3aa0d3ce6f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "no_self_update")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_path_exists testpath/"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
