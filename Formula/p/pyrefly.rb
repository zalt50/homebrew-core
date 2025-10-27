class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/0.39.0.tar.gz"
  sha256 "e6ab9c06db81023fd74c12d0029cd8b39f39b3571b14723f4fef5cfeac8bc9c4"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e654015959cf85ec9febf58636cfe291687c4417fbc44a521cd8d7be0a50b004"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e4c955f45d0a57433b928e970b2f66f59b80007f59884465dcac8b1caa7feb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33f9d29cdf6a7a1c3d98baad7a25613c3fdd655fb101f61c8c5e97054a0f24a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "122279d15a48a6a4ce4e30a6025c55346a3072dee11902c040030632194e7068"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7b70749d09ba548b5314d1e348966b7ff9bc60e686534031174b73e4b067b4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c01f623cf2a62609a406a2b5808f0bcd73322b8532387d17f2b8f2ebe3dee7e3"
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
