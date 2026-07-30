class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.47.tar.gz"
  sha256 "c1758199344cf5e580b7ec1d1583a87f2be1f32ee2683a0494cdc47cb5633889"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "faecf60d099a232f3cf821c5cca66ea41154696c5acc12e390b18b1527296462"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8341f4974142bdc94bf99138e6d188486d5971a67ee7e39d81f0d910ae14321"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ac77b92890c5eec1c314f580aeec55733c3e2890b9e8a85282546347c68b187"
    sha256 cellar: :any_skip_relocation, sonoma:        "966c98b5ea0aa87b966f1cd5c4d55211f3c6216fa78b7631f61453ade84dede5"
    sha256 cellar: :any,                 arm64_linux:   "31e0d0311034dcd9dc3c8181d92c9f6da8fd0cd4440d7ec1096911801c2972e9"
    sha256 cellar: :any,                 x86_64_linux:  "a9ab7221368c6a0fd092ccab613fae6ce33cd33805acfbffc7ee71a96657d5ac"
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
