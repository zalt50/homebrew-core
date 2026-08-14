class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.62.tar.gz"
  sha256 "1b44bd4eb61b7840fe30e8b6e817733908b5273dfe715122672f5cfb98fd2f4f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e58c16d1fb436795b922b62069e12528e6e1702a6f0a3619dca6a7380b797d5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48eccbd2ac315c17c6f5a7238d2f9da5132a8a4c0b09696fef7201f0370e4876"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a6501224dea96f6b08a3c4ab92a7cd29b338e853e04b77ab643f517f714d229"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cf7cdc5af67940536f3474cf17ee272a83ac19dd765036682c567c74f12d12f"
    sha256 cellar: :any,                 arm64_linux:   "377183aaa5fe7a87429a2183298b2e9b0bde2bb631b2486ad6601ee1bd25079b"
    sha256 cellar: :any,                 x86_64_linux:  "58da8bc13382610a5b865717c0b71d2de9c5765f66e19b49cd0489b73d8edf07"
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
