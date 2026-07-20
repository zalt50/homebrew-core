class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v5.3.1.tar.gz"
  sha256 "bd8298d8e232840b71e66c88249b91bf0b2e6d1aa320ad3fc405a002c521885c"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b6e6dc586dde849c2c512c6ab6ff770ea737783da3a700f0e2c6ca1d098ec12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5aab8a2503201ac21503c8de9b0faf58013eb0383aa69754f1d883ec8aae7c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78592340faa5761145cacc6090cd1d44d4de6b6cfcb9aaac2510efb7ed2ffee2"
    sha256 cellar: :any_skip_relocation, sonoma:        "abd6b838f22ec15160a441339051f828d5703c2f7dd4ff25095087d0bc91ef24"
    sha256 cellar: :any,                 arm64_linux:   "1b1bb109a4c89ccf7dc4c52f26a71bcb128bebb74bdceec45e92cfee552c30d9"
    sha256 cellar: :any,                 x86_64_linux:  "65a1eed84307120c3a1d887efb6de3d23b4395bf07f18ff2f81b2e26412a4157"
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
