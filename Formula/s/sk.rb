class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v5.1.2.tar.gz"
  sha256 "6a6e0dbc2ab5241da7520b6c64e6dc423c901fbc3b4c803dfdd198e06d16dd14"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8caaf263f36ee1b64e212437cdcc56f00ce353bd18d4d826a279ead209d95af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de77e9bef92cd022ecfb29b589548274c49f8bb6a48b8c6b85635b511f840b58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abf5d681a53d432272c3a9cc3dc33ae20d7879cd7cc10bdbcb10b1ac8c2dd6ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "5af242dead2d39292ee1d70241d56098480c59e67f0d89c26bd28ff87b2f2992"
    sha256 cellar: :any,                 arm64_linux:   "236ffe55caec9f7318378c6370ca43f51e5c49bb7b0a0933acf5eb23af5c6766"
    sha256 cellar: :any,                 x86_64_linux:  "497468586d6bddf0e04611b977b3954b2a8d37b8e42d2be8add5df3d21f71f23"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sk", "--shell")
    bash_completion.install "shell/key-bindings.bash"
    fish_completion.install "shell/key-bindings.fish" => "skim.fish"
    zsh_completion.install "shell/key-bindings.zsh"
    man1.install buildpath.glob("man/man1/*.1")
    bin.install "bin/sk-tmux"
  end

  test do
    assert_match(/.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld"))
  end
end
