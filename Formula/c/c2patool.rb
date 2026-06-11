class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.67.tar.gz"
  sha256 "392389af2f2af57b44a6bc433453f35ee9fdce6e62c450fd54d9f29c8650c725"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "332b7413d0d800eabe8f187a80bd4b95f6b9e45f970c503dcd99eec1fd6ef911"
    sha256 cellar: :any, arm64_sequoia: "011218f4f36d377aa4b53c22ad131a6d645df2d335c8b69b1b7c09cd23c45e94"
    sha256 cellar: :any, arm64_sonoma:  "4788e324b5178554548a2eca11b23a7c46c374d93bc317af3b8558c3ec5580cf"
    sha256 cellar: :any, sonoma:        "2d92f465705e0e1ea985bcee0263b3c6abda87c69110b082634e44604996a1e3"
    sha256 cellar: :any, arm64_linux:   "0cd6460a84bc0b08edc3e6b7d1059e5496d6bdeb07d6abcc8e8f6782436c5a4b"
    sha256 cellar: :any, x86_64_linux:  "3d6daf654724242c4041f62a2239d370a1eebd3cd2d54048839226f374007bd2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix
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
