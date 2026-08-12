class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://ataraxy-labs.github.io/weave/"
  url "https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "0428b6f088c44da7aa17cc07fbbfc7cfe64f7ffe5a92c1918f1e4db874d0cf1a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3a72b4c30cb252d8a6c0a4b21d938fa600e5ef11794a9eccc850d3a035ab359b"
    sha256 cellar: :any, arm64_sequoia: "bd5453ddafcb455a18944a70e2abd02ba0ece97a90ea287bfa2d09f9c4fee66b"
    sha256 cellar: :any, arm64_sonoma:  "1a59a2f47a47829576cc3c8b8e266b140777dc4b8a121d79837bed13d999975e"
    sha256 cellar: :any, sonoma:        "b07bd47a6d3ef5aa0828f9f933917f72062e9ca1aaa84614893df5aab72ed776"
    sha256 cellar: :any, arm64_linux:   "50e5073d1daebaeb751cf53d2b7ae24008ba067602321304373767c49bce9b98"
    sha256 cellar: :any, x86_64_linux:  "66a0ba14f9eb300f0b6e69b0e3147e4038109991bbba69203dd3bc533fcdb2f2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "texlive", because: "both install a `weave` binary"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/weave-cli")
    system "cargo", "install", *std_cargo_args(path: "crates/weave-driver")
  end

  test do
    (testpath/"hello.py").write <<~PYTHON
      def greet():
          print("hello")

      def farewell():
          print("bye")
    PYTHON
    system "git", "init", testpath
    system "git", "-C", testpath, "add", "."
    system "git", "-C", testpath, "commit", "-m", "init"

    output = shell_output("#{bin}/weave setup 2>&1")
    assert_match "weave", output.downcase
  end
end
