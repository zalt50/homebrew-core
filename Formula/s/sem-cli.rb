class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "576edb8a1e39ca06abac5b7b21ebe5474d081b81a84569f10ced0514cff574d2"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8d411763248fa971d6aa2acafee2fd86a35702417a3d5a4e5a1fa1f295d4ff86"
    sha256 cellar: :any, arm64_sequoia: "563bed217703988ad955de119183bacdd44de86fcc82b97dc1ff723d410164d2"
    sha256 cellar: :any, arm64_sonoma:  "593eda6f7829fea3c1d9eaa942e09e052477c3a08fc418fb81e5bfd3485b56c6"
    sha256 cellar: :any, sonoma:        "dd4ecbb2caafe519b14f9aa1861dc1e810f7a9bdf40194896b2d7b2193542b15"
    sha256 cellar: :any, arm64_linux:   "46dd3a711a94e754b6742099eed3b3635bcd56e16c66e0522a4e5744324ef88d"
    sha256 cellar: :any, x86_64_linux:  "b6c21c18cc86ffa37ed58da214150a73dfabc7dc1cb7b58f9b19312e481265bb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
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
