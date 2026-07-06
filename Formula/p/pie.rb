class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.4.8/pie.phar"
  sha256 "ef9f19c2698334aa8ce8fc458c8cf2a31a2fd6a29230216dbde3422343cf952d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ee2ce9ab15b6db415f0c861866d48dcac1773ad1a8ee243dbe158ea2121bfeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ee2ce9ab15b6db415f0c861866d48dcac1773ad1a8ee243dbe158ea2121bfeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ee2ce9ab15b6db415f0c861866d48dcac1773ad1a8ee243dbe158ea2121bfeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "24a9e067a7e88af618739080179ee331e0b850aa9cd1f8d046e239deed79fc05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "720c1b9a8d94ecda67a63846657011cb7a057183d59dd163546ee5ef915d7351"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "720c1b9a8d94ecda67a63846657011cb7a057183d59dd163546ee5ef915d7351"
  end

  depends_on "pkgconf" => :test
  depends_on "re2c" => :test
  depends_on "php"

  def install
    bin.install "pie.phar" => "pie"
    generate_completions_from_executable("php", bin/"pie", "completion")
  end

  test do
    system bin/"pie", "build", "apcu/apcu"
  end
end
