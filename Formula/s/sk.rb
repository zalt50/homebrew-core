class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "e7c83b2d23beee56cc6e6818153f232834e6bb53b77192bcbb353f12762ff8d6"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd5a27ae6d57b1d85976c2e2f0c48c0437b12a2df2616b6df60fdfdf11d5f7ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7edf37da605e4ec8b09263e043ee363392c25b451eceac9207b65dad309b6323"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "382d30e43c47be1e11b95b937c60dbfd2aecf78ce802a9f0f4e19c997de96e51"
    sha256 cellar: :any_skip_relocation, sonoma:        "704ece0b133bffae268a13b25e379e01a4c1434cc433de766339d1b645933178"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac4eb86af5e97ceee452e8a2699b105e9e8f19c0f18a89beac1512cd3a7b9d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80fc9c82bc523f149e9ff77720caab906bd69080249a0eb21d807163c2921a11"
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
