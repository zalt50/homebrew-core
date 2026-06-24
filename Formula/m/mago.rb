class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.40.2/source-code.tar.gz"
  sha256 "8d274d810e99eb7b397d1549a42800f6efe41da5252478ebac115fcc91028e39"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be8f105c3a2bc32776daa48467fe720c1ba53c373b3043679618b36ecf1643c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f4e068397ffe0ee176cb21e574a60a5929c9d072adf865e054244023c1d2c7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b0036aac0335c618f5e3bc85d8ec3dd794f2218f45e60c437ffbbe03e194247"
    sha256 cellar: :any_skip_relocation, sonoma:        "566fc4640bbee7636bd4ec56d47b4d544b7c444c8271ab0a70290a8de4141cdf"
    sha256 cellar: :any,                 arm64_linux:   "79806951b197112f846615fe03fca03943f0ec53320a85f0484c7daba9cb60d6"
    sha256 cellar: :any,                 x86_64_linux:  "4a8e2ff2156038ce8929f276f0fefe9bed5a51a23c58db88060335c84fe268fa"
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
