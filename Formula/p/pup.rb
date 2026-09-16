class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v1.21.1/pup_1.21.1_source.tar.gz"
  sha256 "e04d519f8d7c24299dfbb704d0ef358a765aceceeb46c32af2c80290022b0b67"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e3c21095a180718e0f1922d9e72e30bc18d42ef099f00842857452659aba9b29"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "792e962da3c69e6fcee0ece42fedddd78a1154e9362633cf95b9839b63d16b36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "50c65c6dc5c0267023066191a0d0b9f7795020f73db6cea069121904050dffe6"
    sha256 cellar: :any,                 arm64_linux:       "650c991b59d0ab01ca079a3bdbdfd9f90559583918315295f858f6e0808bb6f2"
    sha256 cellar: :any,                 x86_64_linux:      "ab4a143914b23974252c2187c03c8cc10bb4d2fd9f4046d7c88c6e04f29b33f4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
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
