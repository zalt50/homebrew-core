class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.5.14.tar.gz"
  sha256 "3e0571b193d345e491e8e34882199def7b6cb2fbf55937cd3221933ecaf30be1"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a8ee60086f05dcac8c262f9e090c74581c46c6e920c1c62c95d40cc2e9509f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c42d946672d98cf5c103e3f09e08885986f85cb1470a795d347d588e9e9af4f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9e8c6af17d3a7c68427ea4a049e8dd94a5bf26870479e123f908130af1cf452"
    sha256 cellar: :any_skip_relocation, sonoma:        "06c39d1ae4064d1eeb0dc457e997dda6bd30c06542de7313c419fc0a01495d39"
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
