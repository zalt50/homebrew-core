class Kekkai < Formula
  desc "File integrity monitoring tool"
  homepage "https://github.com/catatsuy/kekkai"
  url "https://github.com/catatsuy/kekkai/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "850922716fa9d4efd270261ca5de050d85d775a28cdc3a289fb9e9e3f7f5e495"
  license "MIT"
  head "https://github.com/catatsuy/kekkai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c8499f08924e13c7caecb6b6d338a1524c0e74656ccaa358baa07c2063dd798"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c8499f08924e13c7caecb6b6d338a1524c0e74656ccaa358baa07c2063dd798"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c8499f08924e13c7caecb6b6d338a1524c0e74656ccaa358baa07c2063dd798"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5da0937c78d766cae7a54687da0862a16e0dcd8467455e49f81843f02916eda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdd46c65675a8e82955676b1466d4454703d278aa3f9cc4f3f5f967b31de43e4"
    sha256 cellar: :any,                 x86_64_linux:  "1abfb7babfbf7afa58f1fcb44c65716d2ed4aae8d1a74ea6cdc63cf5793d320e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/catatsuy/kekkai/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kekkai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kekkai version")

    system bin/"kekkai", "generate", "--output", "kekkai-manifest.json"
    assert_match "files", (testpath/"kekkai-manifest.json").read
  end
end
