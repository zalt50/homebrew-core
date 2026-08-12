class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.5.22.tar.gz"
  sha256 "b004ef70913c389290716bdc142a7d431269480c5a64b7d6ec8e1a58f44399a7"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81e3de7c9ca314ab46dff94a3225151691a443f4551e3007d4f3f5650890431b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3caf0bc02e8020fe48243cbaf07cd8101364db6418657eb41b160f1707fff834"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59de7a9e90de1efdba182e57cd543839e0c9b5647224738d7fc090e605b47a69"
    sha256 cellar: :any_skip_relocation, sonoma:        "9eb095aad8637e1b019925a5ea510e323f8ca16820e9ab49d0715c8658207c13"
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
