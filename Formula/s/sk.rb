class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v5.1.3.tar.gz"
  sha256 "e348fa7690c9e1fe33ecf8f162324101214a658082e887e9372dd264dbea6f48"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19e8c9c24dbaa070489f8522ae7f3a1ff4b5e1b28f8de614787a46b13b2f728f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ec0fef6f147db880dcc3b96aa5650f952ca6102bfc54905d21dacb6e4825556"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2af2fde56c600180ea5e9899a940fed419e6257eb39a8dede05e5a27b0387f14"
    sha256 cellar: :any_skip_relocation, sonoma:        "608867f4f06aba9584341fa078296cff0f0c17abdb17cec61bb43b957d9a81c6"
    sha256 cellar: :any,                 arm64_linux:   "657b513f85cb8237541648c7417b767a7f71d7fcbd55c60369c5b4a552b3adeb"
    sha256 cellar: :any,                 x86_64_linux:  "a9d29eb9da63e0910e23dd45e3fc378a0ba3d52cb9fa18fc9d6c52db67aeadf6"
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
