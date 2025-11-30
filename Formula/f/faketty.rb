class Faketty < Formula
  desc "Wrapper to exec a command in a pty, even if redirecting the output"
  homepage "https://github.com/dtolnay/faketty"
  url "https://github.com/dtolnay/faketty/archive/refs/tags/1.0.19.tar.gz"
  sha256 "9813623a26996153d586fc110752226a7d619242660a61f01b45f964597f5efe"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/faketty.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/faketty --version")

    (testpath/"test.sh").write <<~BASH
      if [[ -t 1 ]]; then
        echo "Hello"
      fi
    BASH
    assert_match "Hello", shell_output("#{bin}/faketty bash test.sh | cat")
  end
end
