class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "9dd1ec7576d43574e6f48342cb96a5087338b4c308460a848f5895f72ddc3bc9"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "810cd1a8d7b8fd7eb91f52c4a12dca935d84825bc37b351fb2a7f0b2ab38d34a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a959a4c2fcaa73b15c1dbc33500913b46652431ff2080c6ef2b21e2fb5dfb568"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9a387723fd85c6c45ff6b2f9f6cd0f28897c11fbe5a4d087be8402fa5d70073b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "80a6ec6ad5cacbbd7b85fe48884b84bfa8765bc91d40ab5811536b7ec42ee30f"
    sha256 cellar: :any_skip_relocation, sonoma:            "eadeb1f952f6fdf552800939c71ae43f7e20df8e3e14d8f3c4760e8da714bb1f"
    sha256 cellar: :any,                 arm64_linux:       "db0bdd78f8b22e1e256a695af1c0cde94b94d10ac98d2152273330a63858a095"
    sha256 cellar: :any,                 x86_64_linux:      "f2c79cba60ce1bdefd759502d5be8f68482bbd76daaeac6b4f0abc4fd453b6df"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/dust.bash" => "dust"
    fish_completion.install "completions/dust.fish"
    zsh_completion.install "completions/_dust"

    man1.install "man-page/dust.1"
  end

  test do
    # failed with Linux CI run, but works with local run
    # https://github.com/Homebrew/homebrew-core/pull/121789#issuecomment-1407749790
    if OS.linux?
      system bin/"dust", "-n", "1"
    else
      assert_match(/\d+.+?\./, shell_output("#{bin}/dust -n 1"))
    end
  end
end
