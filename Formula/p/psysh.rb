class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.12.23/psysh-v0.12.23.tar.gz"
  sha256 "846a39fcfde38e4c8721ed7b8ca1ccaf106315a0e512cbfcede699998ee8b1cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8921e84298d1bd1eea9028097bf98d2e93968ff8c6167bf57f2fd2f4e1d4b9ad"
  end

  depends_on "php"

  def install
    bin.install "psysh" => "psysh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/psysh --version")

    (testpath/"src/hello.php").write <<~PHP
      <?php echo 'hello brew';
    PHP

    assert_match "hello brew", shell_output("#{bin}/psysh -n src/hello.php")
  end
end
