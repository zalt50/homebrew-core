class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/0.39.3.tar.gz"
  sha256 "9b84a0c25cb3dee9628c4b42b7ac6ed2e02e269b4602322ad97b0f6862ca8530"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "baba9030b21ad2c1effc5ad79b82b98a8e1bd0f0f3e883a00a322d4c8b251d1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efdc5feed6e5a170be31155fcf69f9599df18ef50d8c19d20c9d74afcd8e8c30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1312f4ff1a46c6c74ed91b6f126b19304fd3f6e6ddd786470aa9963d1160c50e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f193c55f0b73008d0411d5f69fe693fc6ae3c9d55285af13bb09761be3ba028"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9eedad862dbf80fc9e217681153a064aaeaa6436ae17afba1f2df561401e666"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4345e001843019e666e1d120a903f09eec8c93b927483a5259f21fa55afd08b5"
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
