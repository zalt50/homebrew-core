class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v2.3.7/pup_2.3.7_source.tar.gz"
  sha256 "954339f37c241a13ff278821506edc466040b33eae038bcb29f3253d3e2f0b5b"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d81efc128e918a451a21318159038ff6313775bccf2aaac9644997c727db3b48"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bd88b1ba9850d9d75f6203ab23bbee3aa9e9ab00832030cff7df4b903b5cc32b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "15b31cff6517e28f8efaa53d8de64a6f1a67b97bd17d97cc80b7beaa006b940b"
    sha256 cellar: :any,                 arm64_linux:       "cf6813c579a3933968b3dee0ccb14d837182204b7b1edef7700986520aea7719"
    sha256 cellar: :any,                 x86_64_linux:      "33c2a3c9afde1e2e9abfbbad2971ea3eae4e3648dfaa7f1913a6dce0fb1207db"
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
