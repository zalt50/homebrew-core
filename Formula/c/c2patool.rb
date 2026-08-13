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
    sha256 cellar: :any, arm64_tahoe:   "872ae376ccbb7b7ce150e3cd4a8928691b3b0156bf4f8687744243b003a3c7d8"
    sha256 cellar: :any, arm64_sequoia: "3d55ac7a72b64467cf4a7d80c4a688199b1f889e95b48b19ffcd7bc1b1d89c0f"
    sha256 cellar: :any, arm64_sonoma:  "218d14fdb5a3306ce8caf8b188dc61ad1c4d798bd79737359cc6585fbd9f515d"
    sha256 cellar: :any, sonoma:        "a266621cd9faa1b28e17c44bb49ffe0ba8ce3a0f6be8155b544648cad4ed8f22"
    sha256 cellar: :any, arm64_linux:   "ab68ce54e21315095e2f532625e28a9870316c153f9bd9d070e57bc5c4b52fc7"
    sha256 cellar: :any, x86_64_linux:  "7f7ad5fe7322f915ec04797dc7acaedcaddee2bc6b382348e97f48d9f373f331"
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
