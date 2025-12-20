class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  # github tarball has issue, https://github.com/carthage-software/mago/issues/794
  url "https://static.crates.io/crates/mago/mago-1.0.1.crate"
  sha256 "ae006028fd4ae826913f8b2b960dec49ca5985284a51d1627ba22c04ebacca94"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61c3fb89ee21e4b2e0228382b1a3f59fc78f80685c57abb51eb41c9f4ed94103"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed5b2c0fbc4715a23afa7d203acb6273bf67ff96605cb074e20327daadd964cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e663388f01b340956cb21c6afe4a81244b7e5412c9788259fa9f23a14710bd7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce24000f9db2076c8878c137afaa37fd029bf92c31664f677135a6508a881588"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "995ca025f5fd47865f1d74a536f3b4c04a1dccc738d9c970cd26f82d16d87433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a3255212c139f951538fe46dda60c5e4af66ea1678f300e7ebc0c1dd330dc24"
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
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end
