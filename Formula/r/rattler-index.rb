class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.30.6.tar.gz"
  sha256 "4ed4ac29d5eba4673ea18dba943dd3192c896d1c46b07fe97069c21d5e0e53e3"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63594cb4a03fd9210a855db3fba3faf359eaca0ca4f3e4ad03b868e8294fc371"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43f433356b14c931e4f587856016ab095ecfb0ee62b09ebf8efa5f6870c2a7c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a578a55baf60f6454a514fe5804ad7a7b1f829d3ae34bb5178f011fcd332ac09"
    sha256 cellar: :any_skip_relocation, sonoma:        "959d6330b91cfb0293a8367ae26bba1c3fd59fe00b9adb86ba5aaad606ef747b"
    sha256 cellar: :any,                 arm64_linux:   "5e4d42900340598c14a733c87780179cb44d0cbe4bffd7f72201e35d1cc1e6c0"
    sha256 cellar: :any,                 x86_64_linux:  "230a68b39da0134b4c4479431067e0ea7e4e6c2bae6cdadb97106b82599fc367"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
    features = %w[native-tls s3]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/rattler_index", features:)
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end
