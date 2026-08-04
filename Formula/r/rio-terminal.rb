class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "675c268907c4e0c59c019db7a9dca480c19adf863c77b850799807e4d135a7fe"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0ff6f0e149efe37b5f194410ccf61469e738812b93a546664486e7440539ac6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10edaacb1a2e84145bab4b3fa7f8b6f487251cee560f53ab35156f9d0500d184"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "580596c2a69dda3c05bc9382ec80549f7d3aba7f39d77e9a564620103c500d7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6eee807f71a826ef1318844ff70ed85687a109a7104a4dff0cf51562b193a340"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  conflicts_with "rasterio", because: "both install `rio` binaries"
  conflicts_with cask: "rio", because: "both install `rio` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "frontends/rioterm")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")

    system bin/"rio", "--write-config", testpath/"rio.toml"
    assert_path_exists testpath/"rio.toml"
  end
end
