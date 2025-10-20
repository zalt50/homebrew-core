class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.12.13/psysh-v0.12.13.tar.gz"
  sha256 "7f77c0c0223199d11ab1fb9e073e6c090b3f65c625f642535956e26ba91ec060"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ebe835edc2e4b25b2787f7e888f5c93d07af8b1fa4b0a294bd96a09b258d1724"
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
