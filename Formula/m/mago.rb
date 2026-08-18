class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.47.1/source-code.tar.gz"
  sha256 "cfc265c69d6926b4ec488fd16ce047cab4907691db284cf82d877ff562fad223"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97044efb9424e12e02a2d9076d509f7bb06a617ba7ea84fba47e8ba94e073ce1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9afbca1bd01562c08b53ae9f72df25359c0aaf8fd10d743856bb6e178863c3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af781217688180e3f3f77ac607d943034a3926a0fbf23f9f131b6a7462a2c21f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e728030515b72795de3fc90288601d499a5e81f0d70bc86f0408fb05e03a6ba"
    sha256 cellar: :any,                 arm64_linux:   "470725abd45444996bf85aa1076095dc4c8c011e80f7d08c3753b11c18267f2c"
    sha256 cellar: :any,                 x86_64_linux:  "7533a78646ae3cdf346bee9af56342ca5828e87b8689ab7064e1d6bb1a95a8a5"
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
