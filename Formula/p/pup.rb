class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://github.com/DataDog/pup"
  url "https://github.com/DataDog/pup/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "48aff94f87a4682ae6a4f675745cb3d9aab9b59fe3ae8aa857a749788fb915ce"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

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
