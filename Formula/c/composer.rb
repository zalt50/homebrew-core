class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.9.0/composer.phar"
  sha256 "9c3982569587a4d976486635d4b5bbe794156b37b8b205131b00607045332ef1"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d6403ae6fbb99dafa9c3bdbd9c3883d56b4abe850a9e6c77b8546c74d3e74e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d6403ae6fbb99dafa9c3bdbd9c3883d56b4abe850a9e6c77b8546c74d3e74e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d6403ae6fbb99dafa9c3bdbd9c3883d56b4abe850a9e6c77b8546c74d3e74e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1db8dbfc936e3c5318c14b561a327c1c5d0665ca0f47794e64c4c437c12842a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1db8dbfc936e3c5318c14b561a327c1c5d0665ca0f47794e64c4c437c12842a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1db8dbfc936e3c5318c14b561a327c1c5d0665ca0f47794e64c4c437c12842a"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "composer.phar" => "composer"
  end

  test do
    (testpath/"composer.json").write <<~JSON
      {
        "name": "homebrew/test",
        "authors": [
          {
            "name": "Homebrew"
          }
        ],
        "require": {
          "php": ">=5.3.4"
          },
        "autoload": {
          "psr-0": {
            "HelloWorld": "src/"
          }
        }
      }
    JSON

    (testpath/"src/HelloWorld/Greetings.php").write <<~PHP
      <?php

      namespace HelloWorld;

      class Greetings {
        public static function sayHelloWorld() {
          return 'HelloHomebrew';
        }
      }
    PHP

    (testpath/"tests/test.php").write <<~PHP
      <?php

      // Autoload files using the Composer autoloader.
      require_once __DIR__ . '/../vendor/autoload.php';

      use HelloWorld\\Greetings;

      echo Greetings::sayHelloWorld();
    PHP

    system bin/"composer", "install"
    assert_match(/^HelloHomebrew$/, shell_output("php tests/test.php"))
  end
end
