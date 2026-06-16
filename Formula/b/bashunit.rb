class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.40.0/bashunit"
  sha256 "0ee0474803b6e88e7dfa4f4c2486ea8f8e53fd8324134a9fe604ec3df8b5e72c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cf44988c0802d37611e90af442e3f581a174412e3707df3882538ad1d348fedf"
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
