class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.2.50.tar.gz"
  sha256 "8a49a8091fd1c4158e698241de67727abba8067c7ceca5c1058700c73df8f6d7"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c3d08d4176826613dd71669f8f07819b8b02f8b3f97a5bc3d5884dbe788c166"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f59249870524171d5b1b8fdc50a6f42b089d058ce5cc1fee1e084280f78d2e04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4788fdbb7b5a30efa63ecfb238135330139a04ede6d6d74cdd3c1727c64a2370"
    sha256 cellar: :any_skip_relocation, sonoma:        "e98218f7972b1c4dc59fd5638512dc201354d67c9107aa4abcc8fa9cc155795c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56610e98d2918b604c607c93cd37cae9d6004956281c77e9136de5215db1ed95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e53909ea5b3923dcadf97af891a38d7d4916e0bfcd3056f0bd40a36e4597714"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[
      -s -w
      -X github.com/refaktor/rye/runner.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"rye")
    bin.install_symlink "rye" => "ryelang" # for backward compatibility
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rye --version")

    (testpath/"hello.rye").write <<~RYE
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    RYE
    assert_path_exists testpath/"hello.rye"
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_match "Hello Mars\n42", output.strip
  end
end
