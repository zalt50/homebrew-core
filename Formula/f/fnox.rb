class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.35.3.tar.gz"
  sha256 "5df718dd9d7a071e5112baed1b5ccf9e096554ccf2a118bf1af978206836b722"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb4a0428aa80ea72eb6065dc3072e5408e7690e1163d2aa49e929e558a66f04a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b0d98f11372b7b3c1e1ea8e41d80853b255220216c472cb000824c089975678"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f67fb7f7adb425026e4d5e8cfa8593a33c6b4ee505a78efd3c5d26eb1190d340"
    sha256 cellar: :any,                 arm64_linux:       "8808687d14fbd5ec5556dde9c793f2bea3a970287371bb089699f2846cbe2a0f"
    sha256 cellar: :any,                 x86_64_linux:      "94c5f0064a5d511e656bfa2adfd0e2163317c1988f5ab67524befffa7e0a87fb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "age" => :test
  depends_on "usage"

  on_linux do
    depends_on "openssl@3"
    depends_on "systemd" # libudev
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

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
