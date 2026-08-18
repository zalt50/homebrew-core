class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.50.0/bashunit"
  sha256 "1df4d6358292fa972e3870cc6ad5946c06b3fdf162aa796fa108dc1641465b14"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7fd173103a12f719d7e41cac47cf8cb234a311145da157fc4e28a36ef81d6cd7"
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
