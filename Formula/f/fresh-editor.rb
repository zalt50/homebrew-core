class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.12.tar.gz"
  sha256 "d709a3538d098d90af754d26d7d797315b5b8b4fb820d4201686f993bc580830"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "970300726d0deca64ae81ccf33f7211b01f7c8548bcd8d98e3231e272a73b7a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5276efff4f8e72b4742fb595f0ddab5e923e14762e52d7d488f5e161ae16e7d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96bd703f02e8bad7577ef31398827af919adcb98a350d8e9b9004d4fd9277638"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dc26ad9ef5d22ead6a53029868f0b25ed41e55722c5fce0aedf72629e64607f"
    sha256 cellar: :any,                 arm64_linux:   "0a36bbfdaf08c293e9d02f6cbf39dcbec7993347aad564dd199daa48633a4beb"
    sha256 cellar: :any,                 x86_64_linux:  "8593ed91ae56b527d051d8c0d9d2244b49bdde22c1fa5ea1d16f44549056578f"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end
