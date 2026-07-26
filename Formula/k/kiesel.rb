class Kiesel < Formula
  desc "JavaScript engine written in Zig"
  homepage "https://kiesel.dev/"
  url "https://codeberg.org/kiesel-js/kiesel/archive/0.3.0.tar.gz"
  sha256 "ead71398e6a6f12266b73492ff2f8e9a8c76b0294ebda71cd0e11e634b4c8273"
  license "MIT"
  head "https://codeberg.org/kiesel-js/kiesel.git", branch: "main"

  depends_on "rust" => :build
  depends_on "zig" => :build

  def install
    system "zig", "build", "-Dversion-string=#{version}", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kiesel --version")

    (testpath/"test.js").write <<~JAVASCRIPT
      Kiesel.print(21 * 2);
    JAVASCRIPT

    assert_match "42", shell_output("#{bin}/kiesel test.js")
  end
end
