class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.5.20.tar.gz"
  sha256 "f2823b69b2ba4b4107382835a7196192c7ad193e5a4acd1da6b140da9820a8b0"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d89fae2a270df3e190bc1d99d5cf254ab4649e0933521afd5f4e9310bf44af78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acd32de6cd752a543126de42e06e8e843a22149aced6cfbb8fa5a333be220326"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ce38d87d4f22e18901df083bd7476e0f4c5e26b21d2731b2ee242c98d0d6559"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4992a31e8f067f03cd8b164af2d352cd4f2fe0948369c49e81b2872f32b44df"
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
