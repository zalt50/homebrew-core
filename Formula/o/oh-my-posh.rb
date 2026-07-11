class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.26.1.tar.gz"
  sha256 "d855117eb43f357bb2a49981b06a90dd1184047177c21c1efeecd7164aec96d9"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbb40d268a5fb0a736466added8da0fb418762bec763e525d01e34dd8725249d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6509e8204c241f439fa6850cb6bd4e32d9f0aaaf0005f340691d307e075a9c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c54275924fcad43e5f64d1e469b6f41a0c3a8cac5c8697f9360cb060b348a58"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdd81903c6eff851d5fa46a5e4319c613afb28994f38a327d961407247e91440"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "260a7f3e73aa1ad47aab58171dcfe0d021918ff0b60f2ca98c7de69d6cf8af38"
    sha256 cellar: :any,                 x86_64_linux:  "125c992e984350c56d0a3077f949a668a5946d8f8ea596db7a2f181fc70cf04b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end
