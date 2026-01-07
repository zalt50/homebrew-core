class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "9a82d8b8518eaaff52261b9d7a3eafb34772670f12d33fd03b3b2d40a64a1931"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30532a307bb93b51a55a613c887e0259e6c173f307d748bb2cfd33881b02fa41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "500fab4ea92a4d59cb1b9f4f5a7301b16d8b87eeca61383d5093842a4d9c1bd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70673e4cbec4763d958fc9837e210ee3fdaf31053f282f6507043630e03ad46d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e400e4c7c0f80e8050ea80b4fec1b4dbaaf51327465118f105ba0e59a1fd963"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fb2dcbddd56d3020ba993284b37615d25f2bd274627f9d8e2151e03183c3e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1714f978f4409b134c6ad5fc9b8084fc5eb0c078d639642f843d4f4dccacd44d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
