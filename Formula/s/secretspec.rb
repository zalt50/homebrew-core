class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://github.com/cachix/secretspec/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "2593e2322b8ee253fd42ffbec57eaa0612a8a78861ee856f6cd8b7252054bb9d"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b7c720099462208a9a035ec5a4c349fe6cc45fe1cdbcb32272aa351346ac029"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "672d237e539690a37246d97a7b3d70be7d35ad3821d537a94ff4a93525df19af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe3db73cac6e93bfe87be40c363afd8a3d39402335f7c4696fbe6033aff69250"
    sha256 cellar: :any_skip_relocation, sonoma:        "f48974e7ca1656d567ad887181ee4c3233fffd027c18a0275ab86b733a3170c1"
    sha256 cellar: :any,                 arm64_linux:   "44dd88246de1ac0d9ca8a1d8b6568948d0837ab799b5fe0bf6d307a23cb38ca4"
    sha256 cellar: :any,                 x86_64_linux:  "cbd46b8f082cec85bb293d7743c758e00d3da4abb829aebce779a70868350473"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "secretspec")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secretspec --version")
    system bin/"secretspec", "init"
    assert_path_exists testpath/"secretspec.toml"
  end
end
