class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.54.tar.gz"
  sha256 "4aa0b42a5836fdc6cbf4ee05e438f1476ab43e63c98aee765ecccf59f4461a72"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55e633574f2ef0b626271637cbebc4c1a70736471b42c51c37a14dad607d39ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a57d332b0a18cd4950c862711f5d4c36b7ce6ab852e8ded97ba129048afb2b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7745b535fdbd6a64de926e1f3480059e9feac4280ffc24d4489a33d4d995f45"
    sha256 cellar: :any_skip_relocation, sonoma:        "b64e72da3dae27b41dfff44c89f161235378fb57ce43cda1e48913a8d3379822"
    sha256 cellar: :any,                 arm64_linux:   "0564c87cf5ca6f52e1882302ce4d6c524f8a18f6c058386f6054de257eac0efb"
    sha256 cellar: :any,                 x86_64_linux:  "fb00606e6993a55833a12ab81afbf9db0b085d54d3e6a3d4ec919d494253ed99"
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
