class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "2d8d090e19ad9ddd12b4686ad301509a15dfa8678b62e9b1f319e9b86bc0a211"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "68d935e7cd5399e4cc656d6be1e48df86b60ccd0550a341bcd6f714771c4a370"
    sha256 cellar: :any, arm64_sequoia: "8e86418946656ac70dea118b133b335b75e2e3885cb02a285c16d792c9ea1e78"
    sha256 cellar: :any, arm64_sonoma:  "57559d654b485a3c1b45b6bef41a8afe2b1ddf2efd36bae1a7bfcf0b9801622b"
    sha256 cellar: :any, sonoma:        "5c60f3f1c7401fefba935196a7bf3a25f97f9854cafaca0a9c5c3a169fde605b"
    sha256 cellar: :any, arm64_linux:   "dd65417729495820183d67c57970acb15070fc9c1eb0c4a7def6f9804109088b"
    sha256 cellar: :any, x86_64_linux:  "d13a0f615aab7b3f1f316dae13569b9a5d98f2f74408b3414dff2c583084dc23"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Bump crate versions the v0.21.1 tag missed so `sem --version` is correct, upstream PR ref, https://github.com/Ataraxy-Labs/sem/pull/480
  patch do
    url "https://github.com/Ataraxy-Labs/sem/commit/0a9b9e25b87c1899b4f845bf53d460077a8bea3a.patch?full_index=1"
    sha256 "bd1d92be66831a60e5c426c18f57f776ccd8ea9105c3d4006b29753630b0d2d8"
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
