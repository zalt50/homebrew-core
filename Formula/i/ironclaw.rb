class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://github.com/nearai/ironclaw/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "d69678e95ad4f447f6ffcdf88175783c77ebb11b8c0c3806e279b41e3aca8e60"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc5ce640c4d362425dcbdc51a51910b100c3bc57918baf9481416395a0a73dd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58299c47422658a247af06ef58f44d3bdc1cd9fa3b6b06888698db3bacf58e23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39bc6b2b2c84729a7f76974b26c4d61f31c062608d0e26b0684f663880a1f299"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7d5bf2b6df58978066ac8df5e6ca910d87f2f0eed5475c98e2c70079b00a2b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f96818d8eb961e53406134ae1e849546624ba37d7900f51b4fd05f3fb160000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ad5b95d0b0584fe5b43c4516facdfe3b6f760592039d7cba10af535796289ad"
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
