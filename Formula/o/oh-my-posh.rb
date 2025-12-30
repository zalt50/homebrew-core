class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v28.8.0.tar.gz"
  sha256 "ec09af9f38e33075079e3de5432adc88af0c7c10db9e01689480957741e58031"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8017cec150a03429f38819283fee4371243a4d9f95bab9977212eb703fc64f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7573aede876778c0a025a1ddbf0f63f6e4341ac24904bfe48b8d5d44b1d04f63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f37b4e6096ac559f596495f074ee0e43b590e68e94ff7a761b7f75726457317"
    sha256 cellar: :any_skip_relocation, sonoma:        "c60f025694ee85d7156290173207e6c7c514a722c3e438e55ff85668c9359369"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83d18a181b55528730e8ac8aeb268da21c3419f63151ef5329bef8e8c904d5a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6451ccb46b414ea38ce93f1dfdde153414b2573b26af22df0191697af06db727"
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
