class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "9e885a778615b1669a2f7f0d54eeb0ee5e4d4f4d0754f142bfd6b1ee0ebbce35"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a30c34f35e2fbe635dae739f9e04ef23a7a9a5f8191f93986d6d71c3b20fe8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6948a2ba1175bc2e6fc083d845c8153ac494dd0e42b4e7d6aa8fbf6bb14c8e69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22de3173fce773a1cfae51767a96edeb91b1588a9de836bf81446b3bf89bb8c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2195b207729163cf17fccabebde79311cc903d65222f0f42c414fdf620d88b8c"
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
