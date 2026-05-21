class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "485e621d220174a472a03a3aa92e3e8738ec16b33ff714e9d0a1faa467970835"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4faf59b7c16aa4d645aca3029268e5aaa93e14606d5f734a4592dd943a43fce0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11534a93b80947a3a5f637ba78d4e153fbdc4116974ec71451458084d288afda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b71c1008dda0fa5c88acd14bbdb3118c5828b26047e0f70d04738195bc137265"
    sha256 cellar: :any_skip_relocation, sonoma:        "71a511138b9985c15f1507e778647f0ae28661f094e71f5ed34b316acb585e58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "781c44079166be5153a44f89ed20c65319b9761434a9e8ba723bd99dd9002178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e61d9466bfc6d40f380ee1b14ec2ca54ca70d4bfeb0da49fd9e6febdb203acdb"
  end

  depends_on "rust" => :build

  def install
    # Restore default features when frizbee supports stable Rust
    # Issue ref: https://github.com/skim-rs/skim/issues/905
    system "cargo", "install", "--no-default-features", *std_cargo_args(features: "cli")

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
