class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.48.0/bashunit"
  sha256 "9e27d930a505fcdc46e0c3275ca943d412e5df4b51dc1f5b5219d794d3b1893d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "773eb79557ef5f272d1c47d7314fcea84367c8e0fc9cee197a91b1512f0a5f81"
  end

  def install
    bin.install "bashunit"
  end

  test do
    (testpath/"test.sh").write <<~SHELL
      function test_addition() {
        local result
        result="$((2 + 2))"

        assert_equals "4" "$result"
      }
    SHELL
    assert "addition", shell_output("#{bin}/bashunit test.sh")

    assert_match version.to_s, shell_output("#{bin}/bashunit --version")
  end
end
