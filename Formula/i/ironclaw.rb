class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://github.com/nearai/ironclaw/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "c395a15af53238130ddf47c86f749f92baa3fa43d2ff7bb0cd1d4a6725ce3a94"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f58bf5a240f67ff5d98b30ef29fbd6bc20ffcb9814e3f325b98fd05f0d673dfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a263eaf7f051c201e2cd723a08e8e81bb371b7a54fc5c15861019b16ad15328"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c911f8f3e523a69149923cea567c1452a9d70a50fa21135cf77bf4deb8a49d3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a67872d4d425c3dddbae66fe147592658abf29ff5cff8016dd1406d0a3ab452c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aadb5d5b9464d08e8e792158912a0fea2c45bc6f2f258eedaa5476e4f7882289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd9d3543d0463e372de3a43b7d46cd2e15506ca201d1510a8068ea5969cb2606"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"ironclaw", "run"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ironclaw --version")
    assert_match "Settings", shell_output("#{bin}/ironclaw config list")
  end
end
