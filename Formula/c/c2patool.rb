class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.64.tar.gz"
  sha256 "4cbe7cb53c12fb1739262a798fca0bb06389f2c3866af28d39e4f3723642dd4f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6d199678e14b6e7d9b4e2d437794457f7a4e039c788f4571f8510e017cddfab6"
    sha256 cellar: :any, arm64_sequoia: "677c9706871e9e7b28919c6b84317e9890f2c188df2e1a490642d4010742d3b3"
    sha256 cellar: :any, arm64_sonoma:  "b5f2c3fd7b63953a46775d512633ca8d7f368c2be75e42d71db123e7e26498b2"
    sha256 cellar: :any, sonoma:        "b8bd75c253e23b50c137f00714f8f72464f74088ad943fed080472fa5a8e9266"
    sha256 cellar: :any, arm64_linux:   "723a13335fe6b3cb6788b292f31633b2dc4fd24dd99f58d865cf29001cdb71ab"
    sha256 cellar: :any, x86_64_linux:  "9e98700a3064d713b3fd270207b736948df9d92e4fc2e53ba4b60d0d35ce3a6a"
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
