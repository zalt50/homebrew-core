class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.39.tar.gz"
  sha256 "72cc8a113d8dc5038604fe8881de37a9f712c771a1cd3b114a8da404f3086a97"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8c4d90c26144ccfc50d52e3bd2980311f873e1ec743e3465c2a92c643c7190e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aeeb1f37dbb5c1abdb1e66814769cec688625b067dcae674e3990c803e4da393"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa105d6682a55a72916c3fb80a60a042907c3c75515798f4f386d3635768cca7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffdc8d60cb40380bf91566c231782bb0741662c9288294599741fc60f41b6613"
    sha256 cellar: :any,                 arm64_linux:   "8aee3fa77d7ec2c2828756169594cdbd5516c8a9251cf1d3d48e3dea2f9f5980"
    sha256 cellar: :any,                 x86_64_linux:  "b7ebff477d88dac6a3ed57e32648775c95ea38276b5b4910b4f0c2597951799e"
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
