class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.40.0/source-code.tar.gz"
  sha256 "67f7fbf10fa9f49004bbc01a6c224df428de4808ae438d40f5f95003542523a9"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6156867d76ee652e7e69357ab6d10965b98e47f16c5ed8675e7b0bd2894691dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6557e1f2d10b212f01a2ed8487e6df0bc4ff67c1bddfc4c5a79bb1beb55b6db3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1b252a9e3fb0911db47f828bcce7bf51c2176103aa124879e056853d3cc450e"
    sha256 cellar: :any_skip_relocation, sonoma:        "66b1a1b84a29a184b65ee2eec34235681483fd0a9dc79d146656298a736394b5"
    sha256 cellar: :any,                 arm64_linux:   "b93fe2171ccca8fce632000ef5c93ed411ab2275f25402d10dfb270f1f1507ec"
    sha256 cellar: :any,                 x86_64_linux:  "aa41ba82158de8ae1690c73633625f6ab319cee23fda7fa8530d88853d2175c4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mago --version")

    (testpath/"example.php").write("<?php echo 'Hello, Mago!';")
    output = shell_output("#{bin}/mago lint . 2>&1")
    assert_match "Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end
