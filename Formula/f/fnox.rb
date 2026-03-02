class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "5addb23a6e41086cf06dfa45b11d5babd9c7951cdd226d49e839f1ee1192c991"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f936a9dbf2e846e120fdf90f15e6bb84853bb2219e4a7bf759cc0efc05efb0b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cef447c132fc57b23fbfe8078442a83b409a33a87aab3d892390732c04d9b90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c69deeab7e9d8fca1967a83faf02601463accdf47e5acacee712071776b24b01"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cc85d1b7d974efa9e0f46abff648a13d4675836df971a62fddbf1dc970c6945"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51efaca180ba8354fbef04cf94ca9c9ae9c7c12a28ef9d92efa58096e12de87e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f631674a8957bca41ae3c501c42972d374ea54e0f34571124ea1e0e59488662"
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
