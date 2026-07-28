class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "22d4840d720fe21cefb3a88c0ad68d2e3df566c2363ec82131e9013393f1f8ef"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "800f86d02a6bccf47f9cc1694746a80c95a6e4b0e5c47f9536365ea91bd1e661"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac9f8847683337ab7dfed9ec09bf9d55d9116a55acfc95a5124e47f3f85d0209"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b261a2da839e0fb10cd8965f11f590c8b54c49f2f1870acf2436a61ceccd0ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "8826b23ac21e131aefa3ba83e455881951a57f75223ff23e6944deda1c915369"
    sha256 cellar: :any,                 arm64_linux:   "cff217a5ab04b34f95af70ed2b928d5569ece205366036c95b520b3542ae1563"
    sha256 cellar: :any,                 x86_64_linux:  "0717642aa42ff07fa4d52e2ed92b520731f28dfcb567d2345e608c8fd3ac4518"
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
