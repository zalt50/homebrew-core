class BatsCore < Formula
  desc "Bash Automated Testing System"
  homepage "https://github.com/bats-core/bats-core"
  url "https://github.com/bats-core/bats-core/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "a85e12b8828271a152b338ca8109aa23493b57950987c8e6dff97ba492772ff3"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f044362c7a483163c2b7498130fbbf76f6e081cf025e5ed25a15817fdeec130a"
  end

  depends_on "coreutils"

  uses_from_macos "bc" => :test

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"test.sh").write <<~SHELL
      @test "addition using bc" {
        result="$(echo 2+2 | bc)"
        [ "$result" -eq 4 ]
      }
    SHELL
    assert_match "addition", shell_output("#{bin}/bats test.sh")
  end
end
