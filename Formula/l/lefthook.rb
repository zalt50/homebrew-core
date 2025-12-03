class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "ee0ad113f8bf44ffc1ee2123591587b2f18ff6cf239563865af69562280af2dc"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cd4cf8dd9ed38af6a56910a3f302191dff37b36c855f8e77e0112c10e2b7083"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cd4cf8dd9ed38af6a56910a3f302191dff37b36c855f8e77e0112c10e2b7083"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cd4cf8dd9ed38af6a56910a3f302191dff37b36c855f8e77e0112c10e2b7083"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9e7c9e41788d89174a8d235c0f2683a7ae218a9a10aabf81f797de98ca023fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80b4f5387190c0dc867658fe03b782a0ff344f17ded654770d7f0e229c7899bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3288a1a65db0b0d96307beff8e909e7685764aa8f33e04ffc9493f52e5483986"
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
