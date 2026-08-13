class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.47.0/bashunit"
  sha256 "defa50ff54c902acf33c17a2813a879defb349452b51f667736800e63c0156ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ce28ec5ed756efa56af413e00c0e72f48e8159147550f943b9493fda9a82fab3"
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
