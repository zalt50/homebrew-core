class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.27.9.tar.gz"
  sha256 "727c51eeb1a104b07f410385fc9c466723c396ce2d11dc1fba7ff5fd5295bcef"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2a59e6c61e79df274341a6b892c71899b3dffa3833a623da7ee6464cca31c7d2"
    sha256 cellar: :any, arm64_sequoia: "a3eb2f7f4fb799649c5d0acbb8e988cf431b43f7e186180538648cdadf797baf"
    sha256 cellar: :any, arm64_sonoma:  "e83b728e6c750d8ecfe1109f600a506013e3039180b68d7bda8be2ae124e53aa"
    sha256 cellar: :any, sonoma:        "2c0070e5057e9c74a2eded1233f18bfa0ef109569724b2be30417c648332e0b6"
    sha256 cellar: :any, arm64_linux:   "408e1127d01c2d251e4ab4e8f2ee9e1a978351fa8604c17ce4bc89edae7f38dd"
    sha256 cellar: :any, x86_64_linux:  "d781a9126b26a9be725b1a660c5f3f17528a84ef762d1585a7d30653a5fa1cb8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/c2patool -V").strip

    (testpath/"test.json").write <<~JSON
      {
        "assertions": [
          {
            "label": "com.example.test",
            "data": {
              "my_key": "my_value"
            }
          }
        ]
      }
    JSON

    system bin/"c2patool", test_fixtures("test.png"), "-m", "test.json", "-o", "signed.png", "--force"

    output = shell_output("#{bin}/c2patool signed.png")
    assert_match "\"issuer\": \"C2PA Test Signing Cert\"", output
  end
end
