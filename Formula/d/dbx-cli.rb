class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.68.tar.gz"
  sha256 "f9d7adabf5ff873f3445ac66e292fc67d31017093003f145ea40a68cadd3a429"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52f1a193b3d376e2e4c75d943ef9dd690c3487a68bb793a1110da91deba90865"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53695a63e2c60bfad415116af2a7c8214d92c6f9a72ce5bc1e3d5dd417fd7c78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57e2a590648ccf9235b288dd65c10d7f073af10562fec38fbf9dc7f6d2ee679d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7eab6cda18520e2cd0a5d2ce04260f191aa422f11c46ad00899ce57285841995"
    sha256 cellar: :any,                 arm64_linux:   "37f47ff0d4d47b8f34ac4d20d07b190cb576a5e4796fd9050a9fa52b490057f8"
    sha256 cellar: :any,                 x86_64_linux:  "5512e5d8e4c484e25d1ac9a43224370ab29f20a1724d7c7923a47e9948e1a625"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dbx-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dbx --version")

    output = shell_output("#{bin}/dbx capabilities --json")
    capabilities = JSON.parse(output)
    assert capabilities.key?("directQueryTypes"), "Missing directQueryTypes"
    assert capabilities.key?("bridgeRequiredTypes"), "Missing bridgeRequiredTypes"
    assert capabilities["directQueryTypes"].is_a?(Array), "directQueryTypes should be an array"
  end
end
