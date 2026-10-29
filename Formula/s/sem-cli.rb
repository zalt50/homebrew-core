class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.28.3.tar.gz"
  sha256 "4755075bcdc4a4720448e6dbf564e4ba6b50bb88efdaa98123e5fbdc5dba1a32"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ba6b06c4957f95ba33bb6e8dfbc72b30357a7b7b93d12fafdfc12cc74e831131"
    sha256 cellar: :any, arm64_tahoe:       "57d7ed981cc62a56c1655f23b3ff3eae4c25cfe7a0a04a69e66d3dc07fba0d8b"
    sha256 cellar: :any, arm64_sequoia:     "7e781e32dfcb3e7ab839f3824a81adfde5669538117ee4d8214b069ad698b3b4"
    sha256 cellar: :any, arm64_linux:       "ad8ddeac2d212497dec0d8f20250090d06c45405829adc58471115a4480eb986"
    sha256 cellar: :any, x86_64_linux:      "15a265295988675db120f2dcb4f6d56e3c054bea3a7ac515ab4300970907274a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "crates/sem-cli/Cargo.toml"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/sem-cli")
  end

  test do
    assert_match "sem #{version}", shell_output("#{bin}/sem --version")

    (testpath/"hello.py").write <<~PYTHON
      def greet():
          print("hello")
    PYTHON
    system "git", "init"
    system "git", "add", "hello.py"
    system "git", "commit", "-m", "init"

    inreplace "hello.py", "hello", "hello world"
    system "git", "add", "hello.py"
    system "git", "commit", "-m", "update"

    output = shell_output("#{bin}/sem diff --commit HEAD --format json")
    json = JSON.parse(output)
    assert_equal 1, json["changes"].length
    assert_equal "function", json["changes"][0]["entityType"]
    assert_equal "greet", json["changes"][0]["entityName"]
  end
end
