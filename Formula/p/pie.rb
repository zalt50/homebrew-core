class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.3.2/pie.phar"
  sha256 "3df6dc2d41f654f26f5a1f9d94ff96373090906d9c5e0b42ad7502dcf19908bd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a02c2445fb646a77fdc18949b348de6c32e0d8d673546a40709f6c65e2a9f675"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a02c2445fb646a77fdc18949b348de6c32e0d8d673546a40709f6c65e2a9f675"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a02c2445fb646a77fdc18949b348de6c32e0d8d673546a40709f6c65e2a9f675"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2f67465348748cf909795ffe22c84b1a5b172487ba7e81c869fe0320f493e88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2f67465348748cf909795ffe22c84b1a5b172487ba7e81c869fe0320f493e88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2f67465348748cf909795ffe22c84b1a5b172487ba7e81c869fe0320f493e88"
  end

  depends_on "php"

  def install
    bin.install "pie.phar" => "pie"
    generate_completions_from_executable("php", bin/"pie", "completion")
  end

  test do
    system bin/"pie", "build", "apcu/apcu"
  end
end
