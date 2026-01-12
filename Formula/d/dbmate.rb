class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.29.1.tar.gz"
  sha256 "70905ffe6b368319f06e72b0fd757e5bec5f23dfac6470d2845117a28ab882b6"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2a242b4baedd1f54c04f8f4aa11225240e43a911b35704cb874b25eb7288e5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7e83a8adcac02696099b262220659d71105e6b79d060d48e371355b60218e02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c884f879691a0dcd10959ad51f9a059f4ac76a58733764219d63b8d3e696d7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "09cb4a16bf48f2c50b2326a3b94452de2ed4ef7026c1e3cb04a526b7b106a9e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a3d316039131ab4ec43ab31811879a8bf1e68c6d767479edbe6562c4a6374dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a166aa3a5502923248c5de3b756e5472e38f561451b8317c5a89182c3bd34da"
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
