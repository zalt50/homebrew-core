class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "1e96ed370cd52e7393bdd8ed519d79fdfeb84b2a1bdd907f61737f665b9a88df"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b6d59393946021b37b59f6495a356494a34883ca4c65e246e2dd0e9a7d7e0e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95b7c5c0601c46dc3b5cfb79e1d34270c194fda319ed1126fb980e18aa2ebdee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15a6348b03b505cbb124768097d3b218b1eb601d92cb350727943d02009e0420"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2048715e9139f475b9d906342ae19b7648cd52a9ad8c54853fe094ce0c48f6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0729a431bba692de283cdefd809d7e28469670dc0d55c27f5e8046eeaa3edbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "203a7d6c504624cb00964c122482e1aabb9d025e4537c70793d17207e921300f"
  end

  depends_on "rust" => :build

  # Add shell fallback
  # https://github.com/jdx/usage/pull/347
  patch do
    url "https://github.com/jdx/usage/commit/1029e4c5d0b20a2ce59be216b7f262326a24c28d.patch?full_index=1"
    sha256 "690247b27e612ce55353e60bc10d65c3601d8a6fba4e5a686f6d324b2230bf82"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
