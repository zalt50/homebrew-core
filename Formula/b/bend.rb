class Bend < Formula
  desc "Language that blocks AI mistakes via proof"
  homepage "https://bend-lang.com"
  url "https://github.com/bendlang/bend/archive/refs/tags/v2.0.23.tar.gz"
  sha256 "c40becbb8ab54fc353c3c4ead02bfaa4e90a65ab488fd56e4e0de5d3f8b745b4"
  license "Apache-2.0"
  head "https://github.com/bendlang/bend.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "29545c2acb01e6556a9c2b9c9fe3844b10d9140ab49b5f7505ce69b1b38dd77a"
  end

  depends_on "bun"

  on_linux do
    depends_on "llvm"
  end

  deny_network_access!

  def install
    libexec.install "bend2", "guide"
    (bin/"bend").write_env_script formula_opt_bin("bun")/"bun", libexec/"bend2/main.ts", BEND_NO_TELEMETRY: "1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bend version")

    (testpath/"test.bend").write <<~BEND
      import Base

      def main() -> U32:
        (2 + 3 : U32)
    BEND
    assert_equal "5\n", shell_output("#{bin}/bend #{testpath}/test.bend")

    system bin/"bend", testpath/"test.bend", "-o", testpath/"test"
    assert_equal "5\n", shell_output(testpath/"test")
  end
end
