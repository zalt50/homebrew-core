class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://github.com/Epistates/treemd/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "096b9f17a5801f7d2e1ab9ebc4dd4eb63e70d5f587a3dfe067fd53fef8cffb12"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d89aaec1520db00da857720d15e06bc0ec4cc4587919837f1080d00597511e4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d6906c5c55c8b47ae112d9c4ffef60a6275a6356838993e91da91ba08992205"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1acd72df788d4858d4ca1589118d5e3215b3d68e1b6314c7a20baaee637b6138"
    sha256 cellar: :any_skip_relocation, sonoma:        "92fcbe47c5fcf2e44a624735cdc64d87a07d403930d15b5d6063af4e914162c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd2598b8ff199b5164846da9acefc9ebf96f00c44f8da87a8a299436b4c612d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94d41b3a6ce6a3997c3cf9518cfeff9ea49589655959bf18126c77a274179cbf"
  end

  depends_on "rust" => :build

  # Fix incorrect version number.
  # Remove in next release.
  patch do
    url "https://github.com/Epistates/treemd/commit/20525eaf5e31ec8df0935703c4845f06fb37c1fa.patch?full_index=1"
    sha256 "4ac9104f8527dd8293ff29b7ef31f85fad5c52775b27a5d78504b532a8ac18b7"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/treemd --version")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"test.md").write("# Test Heading\n\nThis is a test paragraph.")

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"treemd", testpath/"test.md", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "treemd - test.md - 1 headings", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
