class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "cb3afd0acd9e60af4f77e93ead8c5529560f6fe0aff7979bb16b36ae655cf689"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "18704fdf8bcf135bf8a2020cb0f95aa9878a58c0be67ff9ae0c1291110c54fcf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f5dea205cb8c77d4dcbf363c9e97d18cbf84e07385181564d208dfbc14e8b67d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8d780fdc84bfba2018287ad4d78d8634dc9a9d6e9fdb78bd0f6bab953c6e057d"
    sha256 cellar: :any,                 arm64_linux:       "2a83e8cc00d536a636ccffb670013a9be17c1ba09ca1e472f23fcaf142fa082f"
    sha256 cellar: :any,                 x86_64_linux:      "298f8ac4318b93935f10976b4fcdc36c057d0aed5e971559e564e3885075f098"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end
