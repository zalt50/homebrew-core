class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v2.3.2/pup_2.3.2_source.tar.gz"
  sha256 "ab5bf92b0beaf450236813bcbd410846063f07c431c41c4fd65fa112b2e713b2"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "74949a22e8daed8c24462d462ab1697b5b02c5ab059503190c5e4f84d63c4140"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b4010e421f937581e9e083245a18798c7a6b92d4de96867d2bd9d9e0cf6dd086"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "775943380216a07113179c102a4915ba8959a453bceba2e3233eb222bd605f46"
    sha256 cellar: :any,                 arm64_linux:       "daae3f23786aab03bf427dc551c9734e907a6af0dfc935ac32061f63e4adf5a0"
    sha256 cellar: :any,                 x86_64_linux:      "0744b05a40d734089cb066a3f4ee7b212ce75c6ed7f9fcedf0cae5ec3951fa53"
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
