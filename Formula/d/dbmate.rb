class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.34.1.tar.gz"
  sha256 "e55ca18250d00f281e69a8663b65f36a80d0fa6ae04bad3fc9ec89a8fd57bf5a"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20d48da8a9d61c959269392df5b25035a86179b8938c8e57577b4ee0acc39c78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c12c92dff4f26e127dda80e3c64ccd82ed0d7c5930e52fe32cf92d95fae6e459"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53a8e2ecbbf7cf1d30acd00b9a1baa336a734ea419f78483c7c5a61862492bd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "84c3cf65729a5376ced9d2a273bf44ac2d5bc24c05ccdb9aaa4e6e68ea49a55b"
    sha256 cellar: :any,                 arm64_linux:   "490199309c60d22c79d7731a926bc278800e0ea5af073ea9aff3fd5422b09aab"
    sha256 cellar: :any,                 x86_64_linux:  "ffa210c65069774e7395290a4b0988598949d8b010115bcaa7269ff14ccd88ec"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    tags = %w[
      sqlite_omit_load_extension sqlite_json sqlite_fts5
    ]
    system "go", "build", *std_go_args(ldflags: "-s -w", tags:)
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin/"dbmate", "create"
    assert_path_exists testpath/"test.sqlite3", "failed to create test.sqlite3"
  end
end
