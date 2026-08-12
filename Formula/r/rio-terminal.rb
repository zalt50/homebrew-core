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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88c3754fbee5436ae37e860f1ea2f9f8a0b77cd4537612ab818d6516f7609eac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "227fa46b8ba5d813f0a0625ee5a36601b01aaccdcf36dc5327209e8da8401bd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d155264b38df819aa28c1af651256ec3875530e32f2385373ac67f27d413c70e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0c1058a174177a9b5bb454ac6ad187b5427a819578c5550407298bb737a3fcf"
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
