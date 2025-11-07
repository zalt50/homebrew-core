class Hexhog < Formula
  desc "Hex viewer/editor"
  homepage "https://github.com/DVDTSB/hexhog"
  url "https://github.com/DVDTSB/hexhog/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "5858dcb32b3f12647784c9a6ba2e107e157b9a82884bcfed3e994a70c7584b29"
  license "MIT"
  head "https://github.com/DVDTSB/hexhog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b2e7f595bf4326c75c12c57e2a68871a8d5fea82012add3481c19924d7a1640"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8b84d49eae0805cbf492bd7132e3f0d264fc5d0bac3c8de48924152e7b7f859"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "139feabeaed76e99b95211d1873eec9da003514c249080f622bedbe255aae729"
    sha256 cellar: :any_skip_relocation, sonoma:        "491a18427c27d596123b3aba3eb23727baa761170a370c554b63e735e0b676e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4eee337de8005b314544f5269a1933ec14b795a7384ed164a6549d3f9e054a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ca7fa34b0392291d065c22ee2e034a4d05a6fbdb626386d9dab837736cddb46"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hexhog --version")

    # Fails in Linux CI with `No such device or address (os error 6)` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"

      (testpath/"testfile").write("Hello, Hexhog!")
      pid = spawn bin/"hexhog", testpath/"testfile", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "hexhog", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
