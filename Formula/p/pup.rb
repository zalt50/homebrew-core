class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v1.23.4/pup_1.23.4_source.tar.gz"
  sha256 "294b2c5415bb71cd848dfec7dc4d9d21777d4e601c5c8d96af5a9e7e449b97cf"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a5007f67e9c024d825651e6dadf99b968a703e4e09e935b6895379dbf6595990"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "76f5b5062a3f232d3dd6ecde12cfce0ebebb0fed029f1fbf6788686ef4eb3424"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1449e237d5ab49ac3d76296af3d2bb88711056d52bd032eb6845d8bf10a8040b"
    sha256 cellar: :any,                 arm64_linux:       "1a9982f8de6cf80a4d4b64f379641ccfe3c795d05bcd6287564ac74d6d339ec6"
    sha256 cellar: :any,                 x86_64_linux:      "a3435b3dcee83566dce77633ba86eebbf4fbb3580e4d6695c2a58f64666f4e12"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end
