class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://github.com/cachix/secretspec/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "cb125c508300b6ffddf4a176d9523cd415fbdd66e8e89a52af4934189600e45b"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5593f660c297bb3f63721993083acac7a691fabc417c51b578ebd41f991437b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9b01578fed7c7199feb1b2bac202c125beb87eeb9747be0484410069b3351c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "760968b8a72bb9296bfba844011455670b83e1cc00b3f64bdf5c0bbcd8efb06e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5da0040755808adf37a195f8c57ebfd9df5559c05a307c04d5b0ffc1a243d5ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ecbafc253db54a8843ed8dfcbf8f3bb261bb460148af305c13011363dc4616c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cee72f38bbe495380a51c8e49fbf07a72961c2cadac73878e41a5e451ef2e36"
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
