class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "4422f7fba8a0cc1f2917bdefd2f9b718aa470993044900e3aeb9996de15eb285"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4c781cee0f0bbeeb754eec480af42d9a1b34cea8197929a299f8d857d3741ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de848756d3f6de6c956a376df50bbcaada4b0d73bcdafaa7474d97cc9de2442f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea26b383731f0db37e618adf61aaf4dbb8f399121232dde2b5986e0f473daa35"
    sha256 cellar: :any_skip_relocation, sonoma:        "974642ecbdc081042c08d6e94900e02f762d034c7d0e575bfbf4398ef9ebafdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80d66598d13e32837dd6a98f888b2b8630ed79ecc834fbe6a84f9db025295aac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2765b82dfab84224afa3220b1c100342ed6d5511fe7b21858f3d3b29a2ff4676"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "age" => :test
  depends_on "usage"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fnox", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fnox --version")

    test_key = shell_output("age-keygen")
    test_key_line = test_key.lines.grep(/^# public key:/).first.sub(/^# public key: /, "").strip
    secret_key_line = test_key.lines.grep(/^AGE-SECRET-KEY-/).first.strip

    (testpath/"fnox.toml").write <<~TOML
      [providers]
      age = { type = "age", recipients = ["#{test_key_line}"] }
    TOML

    ENV["FNOX_AGE_KEY"] = secret_key_line
    system bin/"fnox", "set", "TEST_SECRET", "test-secret-value", "--provider", "age"
    assert_match "TEST_SECRET", shell_output("#{bin}/fnox list")
    assert_match "test-secret-value", shell_output("#{bin}/fnox get TEST_SECRET")
  end
end
