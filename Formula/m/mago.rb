class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.41.0/source-code.tar.gz"
  sha256 "654e487a6a2c96e48c1c10477b5fd03d337d10c294d8bf64d8960e7dcc103d9b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4de8198978f7a58360c5b30632c2fe36f1a115f5d613558c1745aaaab8cba4ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfab6e06afb605483f39aa3fba8dbd29a6c0e7d85b866506a9bfe47325c95290"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b41f3c5743b4ca7c9750150fc477dcbd47322509dfd898065d829c76700a5d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "436661bf87f52b254c3ddf42c99ee3a9e65d2ba713461593de7f6c6a39df2162"
    sha256 cellar: :any,                 arm64_linux:   "1197ce5ed12bcf1605c61942cedd5f3014ec180113ee27f1cc10677f00385dd5"
    sha256 cellar: :any,                 x86_64_linux:  "cac8cd3bf8ecebb283d88770605a593996404d8852654791d72f20b157159e1f"
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
