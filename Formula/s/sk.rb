class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v5.1.4.tar.gz"
  sha256 "ae42fafdcdcce980b55eb0db3e973f248b418211b41571ccd82bbd57cd2c12b5"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f396d4d9f4e146e9b3efb0d34ad5c69220a95abac08553807f3933a707afeef7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb1db677c11b5ef1202ff5b8bdc7adda256180cb7ca583559a7570ce644bf677"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dd7f16fef22fe370ed796682da4e830e08f8f6083687fcc7f1aa5ceeecfb349"
    sha256 cellar: :any_skip_relocation, sonoma:        "7743806527ef46b7b1c5f487aa01233b709489eed8bad55d3dfd54c0b8ca87be"
    sha256 cellar: :any,                 arm64_linux:   "fbc6abdb57dedeb10b43bb9e16c34157c25a929a3face4b9159b38101fcc09d0"
    sha256 cellar: :any,                 x86_64_linux:  "5386a83c81a05b78dd6a629be343116be6e2b7945f7ea57989eac8611d075f95"
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
