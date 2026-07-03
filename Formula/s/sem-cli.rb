class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "91da1105ecb52f32511090d3cbc7bf762d18dd697510a08ac70113d4c3df54d3"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "314923a991c912097a477243cbec110ead1b5b4640d91752d5440e5afa0841fc"
    sha256 cellar: :any, arm64_sequoia: "3c317bc475f5c7cc222c2b9b99b9f89665bfba1fa6048b8969a0c3bcc5f1db53"
    sha256 cellar: :any, arm64_sonoma:  "1e8a9fa6c3f07caec9830c56412092b128e426b84f1ddfeb26354ee913fe210c"
    sha256 cellar: :any, sonoma:        "51539377e0c0e42648f8496958844599230b8cb6300e0a2520f61d3d67271b00"
    sha256 cellar: :any, arm64_linux:   "aa9cf03cdb8e846dd96ebc6e9a92c72daac61a0149a95ce285e359b044ea1828"
    sha256 cellar: :any, x86_64_linux:  "ef7e6295d844d7476ef575042e8e80c2dc4a46039901a9ffc67580c68552673b"
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
