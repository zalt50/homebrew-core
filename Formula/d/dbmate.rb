class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.29.2.tar.gz"
  sha256 "8b8a37e95fe3a85ad621c63124959171418a95970e20d21b968301366d45c4e6"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88af83983601cc4016dffa119b0d099e02a1eb01d5a9519802adcac6988fd3cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a9d8e55907356c7930a45fca823fd217549c6ea58d9b29e308a5587c186b58b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "860328a0676db2ba802dbb978dfe15bb32f7c619cac52fbccbd66e86da95ea26"
    sha256 cellar: :any_skip_relocation, sonoma:        "4992f34ae75eed21d4d98478afa1aea9b6d85e7dfb221cd4ae8e7f8d6aa0054b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d96d7ed8f25dd5b402eb0720da47c37f606ab8fba379e8f7a1ceb6afdab47d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ca022abe19c8a780906b102b9be8e4cee017747471e07fb5e41afbc7ef7809e"
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
