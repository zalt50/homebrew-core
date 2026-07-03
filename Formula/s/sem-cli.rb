class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "ef0efc1e4adf869325deb91248afc065a45aa88279787ea185665307aaed5c96"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "502aa82711dbcb4c13e819d6c21345b70a1383fd5fcc17d037b441fdd958b350"
    sha256 cellar: :any, arm64_sequoia: "14131a862917834d9e8b26c72cf96837a9a4d7ce7c9f1761566678a565212531"
    sha256 cellar: :any, arm64_sonoma:  "babdb7d8222eb34fbdaaaf542ce80c8b4f64f4680dadf6e9103b48993bc4a7ea"
    sha256 cellar: :any, sonoma:        "a9aa6eb28ccae7260341f2c4a5aeeff09ff611c35810dc4576189abaaf1ad480"
    sha256 cellar: :any, arm64_linux:   "1883b4179349b8746f1e48d6828a8f2e87e33f5e3409ca822e1c5cdb2d026441"
    sha256 cellar: :any, x86_64_linux:  "be8931c34028f880ee5f4818ba892568479a1466b786dbb26e8229f38a09771f"
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
