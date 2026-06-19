class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.95.9/php-cs-fixer.phar"
  sha256 "f23a9b6eec84bd514ad2f1efc293066dcac97e3994b4a91f55853947504bb842"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "445c8f255dfa6c8f421e8597ea93eab6b38e771e1766dfdec1d406d54cea7e3f"
  end

  depends_on "php"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~PHP
      #!#{Formula["php"].opt_bin}/php
      <?php require '#{libexec}/php-cs-fixer.phar';
    PHP
  end

  test do
    (testpath/"composer.json").write <<~JSON
      {
        "require": {
          "php": ">=8.0"
        }
      }
    JSON
    (testpath/"test.php").write <<~PHP
      <?php $this->foo(   'homebrew rox'   );
    PHP
    (testpath/"correct_test.php").write <<~PHP
      <?php

      $this->foo('homebrew rox');
    PHP

    (testpath/".php-cs-fixer.dist.php").write <<~PHP
      <?php

      $finder = PhpCsFixer\\Finder::create()
          ->in(__DIR__);

      return (new PhpCsFixer\\Config())
          ->setRiskyAllowed(false)
          ->setRules([
              '@PSR12' => true,
          ])
          ->setFinder($finder);
    PHP

    system bin/"php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
