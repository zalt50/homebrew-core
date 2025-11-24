class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/0.43.1.tar.gz"
  sha256 "177df2825210dd3512ff89507ab7d07da49fb4a3c7a0e9ac82cf4dedefa73010"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41b653d26f44dd12c81159689de26b5e42d99cce3ca657daaabd84e07f97e9a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eea3eea57cc735cdfebff2ed06c2ae3e493d0ca4e76674adb8cd4771b107e5ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0d8af5383361c63173751e6919dd8e0453a6b0ecf2323b3e79d8c5f7ce57bbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb01b9b3f368abc603b699f9a76e891bc1477bb810ca0b74089d168627009899"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af99d785d9d7853449ea9d40c596907aff32636ed5efccf03988c7edbfbd5a6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a90674d156b3fb3c004c644ccc6378c17dac3af797874db0bab7b663d1cbf04d"
  end

  depends_on "rust" => :build

  def install
    # Currently uses nightly rust features. Allow our stable rust to compile
    # these unstable features to avoid needing a rustup-downloaded nightly.
    # See https://rustc-dev-guide.rust-lang.org/building/bootstrapping/what-bootstrapping-does.html#complications-of-bootstrapping
    # Remove when fixed: https://github.com/facebook/pyrefly/issues/374
    ENV["RUSTC_BOOTSTRAP"] = "1"
    # Set JEMALLOC configuration for ARM builds
    ENV["JEMALLOC_SYS_WITH_LG_PAGE"] = "16" if Hardware::CPU.arm?

    system "cargo", "install", *std_cargo_args(path: "pyrefly")
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      def hello(name: str) -> int:
          return f"Hello, {name}!"
    PYTHON

    output = shell_output("#{bin}/pyrefly check #{testpath}/test.py 2>&1", 1)
    assert_match "`str` is not assignable to declared return type `int`", output
  end
end
