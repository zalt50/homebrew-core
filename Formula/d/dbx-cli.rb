class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.52.tar.gz"
  sha256 "59f4726a12e82c853c3ce4c0724ec426dc0a9699579879ce8a34798fa89382e0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c28124b335e0a4bd5614a586c6f1c9148ad48501c119693a70d298d791be7317"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66178d1e80159738a04bfb89fff22b408066f4e0dee0f32d0ee274a4369c62ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aeee1a64c13cd4f78805ae440ea44e278b812cdf8dde2a9d5af5feae5f295bf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a15c0aad645b02b0794037fa36bd27f768b360c22a73a509416cc57f25182d51"
    sha256 cellar: :any,                 arm64_linux:   "194e7dd612512d8060b6ffa9a92ef52c4526fc666e75765a4d916e6fe63a8ec6"
    sha256 cellar: :any,                 x86_64_linux:  "ba2f916291a4cb56dc3041f0bc3fbe71c1254624bbbd5ed34b300111666e2f51"
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
