class Kdash < Formula
  desc "Simple and fast dashboard for Kubernetes"
  homepage "https://kdash.cli.rs/"
  url "https://github.com/kdash-rs/kdash/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "2f856914fc2612857c880a0f2f76ecf458a845874a11c6d4bf6527155f96b44e"
  license "MIT"
  head "https://github.com/kdash-rs/kdash.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kdash --version")

    # failed with Linux CI, `No such device or address (os error 6)` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"kdash", [:out, :err] => output_log.to_s
      sleep 1
      output = output_log.read.gsub(%r{\e\[[\d;?]*[ -/]*[@-~]}, "")
      assert_match "Active Context", output
      assert_match "Resources", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
