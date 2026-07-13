class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.71.tar.gz"
  sha256 "eb7fd6c63421f31a8b4dc244dee738de7cb36f5b99cd27983e337300f639ee33"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "12a07bffe37c58b30c3f64c8a8fa64c007c5abf04f48744a50da5e51fa5772c7"
    sha256 cellar: :any, arm64_sequoia: "42a21889d89bef984da93c3297664d51f7b1dcb4a6a8bedbfb680ddd4e5d3e00"
    sha256 cellar: :any, arm64_sonoma:  "78fea122430ca11d91fedec2cf222c8803284a1bbef62915f2aba7e8598a1e91"
    sha256 cellar: :any, sonoma:        "fa7a12710df1cc2bd000ee9f5c0d6ea16fb79ca6da09d7d8015549bca05a40e9"
    sha256 cellar: :any, arm64_linux:   "4bac50174b0b6d387aba37b9b4e863e3b0053706e695a6ac2ebaec881283f468"
    sha256 cellar: :any, x86_64_linux:  "d473b31355e20a9cc46f3940ecbfb94c898341dbaa9d2096f8e2d7de01d1aa8c"
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
