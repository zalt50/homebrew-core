class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.2.tar.gz"
  sha256 "5e5a506ecebc3863b7d712c75b8d5c06e383a996349df9cc764494c58c2d1ce3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e51ee6e4a33812579d1c27e0873b5d57a82232f4253c2e310f843b6a5341bf7f"
    sha256 cellar: :any,                 arm64_sequoia: "f8e6a6b568fae7f2a739287e548212f9308d89b8e4fcf64efe71574955e6044c"
    sha256 cellar: :any,                 arm64_sonoma:  "133efb10f8f4c29176ca8af340cabf0021d5fdf271f329ec7c0970f1ddca80fe"
    sha256 cellar: :any,                 sonoma:        "27fabc4a0e0330f4264ffaee0329814800cf04d21724d33f85166716b4bdd3b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77e35c692056e36275f7d7962ea79f2984299ee9d0d8df55dfd23b7c084789d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acc1380cbe4edfd2a50dddab630150394ca2b1959d2e02c5c1a78c52772de3eb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  def install
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
