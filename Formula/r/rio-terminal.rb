class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.2.35.tar.gz"
  sha256 "118e169e4a328544a3958da70ae6a8a804edb63294834312ac33faac6130d40f"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d39c38ae963c9bf4f3cd2997ffb46e438c3d0e30b9632a16041e5438ded14299"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18b1cb29729c6093f8688fd1a4d1fbeebb6acc5b1d7043e299d3bd318f6aba68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbf33b910edb3709c3eb466ee7c4224dc13794b11ed24806f66823efc7558480"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f6c5979f917c05b9bc8199e4959dd1d02a587054ee422f31bf663dad751297c"
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
    assert_match "enable-log-file = false", (testpath/"rio.toml").read
  end
end
