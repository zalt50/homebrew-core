class Depsguard < Formula
  desc "Harden package manager configs against supply chain attacks"
  homepage "https://depsguard.com"
  url "https://github.com/arnica/depsguard/archive/refs/tags/v0.1.38.tar.gz"
  sha256 "dcddbf0826245f33efa908a2d24b5c4c78bea587771a44a435a0f739d695587d"
  license "MIT"
  head "https://github.com/arnica/depsguard.git", branch: "main"

  depends_on "rust" => :build

  deny_network_access!

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depsguard --version")

    # With no package manager configs present, scanning the current directory
    # finds nothing to harden and exits successfully.
    system bin/"depsguard", "scan", "--no-search"
  end
end
