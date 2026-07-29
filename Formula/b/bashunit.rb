class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.44.0/bashunit"
  sha256 "d3d8ed473f414bdbcce89e215d489646461f2dc90796d98dba42d9768036900c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "63f0bad9afa5b347e5961b6144750a698e7184d91b485aa15c2693a12a86e114"
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
