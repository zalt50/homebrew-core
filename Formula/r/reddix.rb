class Reddix < Formula
  desc "Reddit, refined for the terminal"
  homepage "https://github.com/ck-zhang/reddix"
  url "https://github.com/ck-zhang/reddix/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "0c1af2b263d3c47cc64acd9addc3ba7c44731f2bace4ee8ad5189eb2a510b9d9"
  license "MIT"
  head "https://github.com/ck-zhang/reddix.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/reddix --version")

    # Fails in Linux CI with "No such device or address (os error 6)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"reddix", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Sign in to load comments", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
