class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v27.4.3.tar.gz"
  sha256 "616ebae1c44add103b0727ec474cf7b7ad5621c1573dc424340868e579be3cb3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1c01ade9da5a96169fbdb95a52aaae768b5b19313358f65fa07b9c423c34049"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "062f779cc11c753c8baeb4bdb21c92a06968594e252d7d8a517474a86929a348"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94a9e139a40899bbf2eff17225c0a233be2a15cc3e09a6190b65b71f218512bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ec0640e4985ebe77920dc7195e394002db3dc401fa9f7faa0db26d1c1298bd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14e55a4d9b4a61976f203d558648736f6af761eebd060514aaf15fb64073ab29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e359d698eae6bbca9390ce31de7981ac8c33ebca23da1abce7a0c247e436afc"
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
