class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v2.0.10.tar.gz"
  sha256 "e308612eb5107c678a6090a459dcb73f1092938230e724c322627e8c8e55307f"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d798bd95fad599ba9753fb9a57bec6a434a8b7330dae25308c1c71a71c96c0d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d798bd95fad599ba9753fb9a57bec6a434a8b7330dae25308c1c71a71c96c0d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d798bd95fad599ba9753fb9a57bec6a434a8b7330dae25308c1c71a71c96c0d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bbdff76ae7edbd13c66dfc15226153511ced1d0dd11f03b33f437904649a069"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3f5dfa939870acac145eaaaeb8d59130ee9164da41006a4fa789a6ad30ec2f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d13cb5c550cd5490922a6d5ca55a5ab9de2e629838a38a6e646d5a4ce0ad607c"
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
