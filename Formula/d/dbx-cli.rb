class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.48.tar.gz"
  sha256 "59a673b294fd3e12c5a74df5c319daa9b3e06d03804dea3fcde855dbdf3cedc1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eab54df24acd35eba15c5f6e41909706a33cc00478f49e5a0c3e5b9eed89cab7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "618d77034e960b8179ba129e58e81a3c4a74bf3c50472dcc6aebc8f5a4655c91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4eecefa651dd3e1cc1cecfe853a94145bcd0c5ca8dc34f9091c34a757eafd441"
    sha256 cellar: :any_skip_relocation, sonoma:        "99836d9a243bfc74a7c3d918b4c50b00e01b19554254d95c8df6ef8b897b7d4a"
    sha256 cellar: :any,                 arm64_linux:   "5f6d99d50cfb1a0920e1e2456a048369021c1cf695ecfb16e37ad5e528ab58e1"
    sha256 cellar: :any,                 x86_64_linux:  "a9881a740804150c0dfdb6dd00e97ede4f3f7c41facf637c7d428ffea6f9d6bb"
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
