class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.12.18/psysh-v0.12.18.tar.gz"
  sha256 "47c35f6e966d6d6a42c61d928369a932be4a2154ffcf8670036932f0a885053b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "50a3378e13d2fc4058f0f0b23cabf6f89443b7fe19735923edfdb8d74395d733"
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
