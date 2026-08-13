class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.27.14.tar.gz"
  sha256 "e19c9a93503abaa3283994d01412fb2a82841e8404c709b413da611a82a144e6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "52d90db8f9b3f924a3838a00e56dedd09ee97aeb0942257cd79c5bc8cebb7d5c"
    sha256 cellar: :any, arm64_sequoia: "85e08c8d0b47a928af55891a45e00b43668aaf60b58e4d4eb0a5f0d8cb515bb2"
    sha256 cellar: :any, arm64_sonoma:  "dde58ff61418de0bf25662370c3269242a1ef18456222cb6347d2aa2e1fde037"
    sha256 cellar: :any, sonoma:        "55d9d37513e3da2d08a8f18111ec6683bf4a0c087e7848d08296ab3137de4c0b"
    sha256 cellar: :any, arm64_linux:   "d2033c986283ccc3a6c6177e4900a17361fddcc5902b72e993676241cc501607"
    sha256 cellar: :any, x86_64_linux:  "5b84cd5dfcd5400a98230509cb27ebd987a61e20fb18fcc1df5c89a53283bec6"
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
