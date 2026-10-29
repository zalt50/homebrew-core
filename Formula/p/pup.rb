class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v2.3.6/pup_2.3.6_source.tar.gz"
  sha256 "b64ca31611f7f625d134b07cc67fbfd49365e69288e7cb46ff7319d70cade932"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8b7ef2f95d40d32e97da2f5405164db6a5d953d7303a431d313b50df270fd57d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d4a8418ea4631cfb2403dadee54b0d5d56ff3e3e5be610f8343ebac705123e36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "190c9dc7cdb644392ac33dcec23a7b72914cd3c0f6bab148d3aed2773c51fbe6"
    sha256 cellar: :any,                 arm64_linux:       "eae366e4b66b79b5d979b28889ae20947bddc95d3497b767af4b3bcb80f5658e"
    sha256 cellar: :any,                 x86_64_linux:      "c1397ddd4d788806828405db57e5d0f68e18a7f8bc9a5709ef99f7259c1d8bd4"
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
