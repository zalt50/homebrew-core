class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "d6e4fb726c68c7737794db60e5c1b717ccf35b5e16ffc9c4eb42a06e95edbf58"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "174bd62af8bd1822fb75b4c25194097368648b2c8b276c2388db8d7bb871ca3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c38509d0784801b16ebc0bb0fec9357103bbead06c83163e015ca698187b063"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "052565f69e7c5deff83990bb92875ab3de6856e9f58d9999283c1ed2df33efe8"
    sha256 cellar: :any_skip_relocation, sonoma:        "81ebd5a886000a6e41a5b949bfaa3f637b850a5ebfc62d02c95535a37f9194c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c629ea4b9891fcdb9edfa51cdd6f39d423d4d6c466e68136961aed24f0ffcf25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac456401b2420387630ffff8d7bb8798cbc7653bbb81367c1326704b86e97e30"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
