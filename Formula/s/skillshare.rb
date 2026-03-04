class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.16.10.tar.gz"
  sha256 "81bd3f20b3d1fcd10786c3a90c0097bcae7714501cad50fa335cf62bed71e9d4"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc16a2c7862a47d6b91b3f3651fa31f68df2bbcce15b733ae148ebd49a8a41e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc16a2c7862a47d6b91b3f3651fa31f68df2bbcce15b733ae148ebd49a8a41e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc16a2c7862a47d6b91b3f3651fa31f68df2bbcce15b733ae148ebd49a8a41e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec6ba633aaa4c4503ccf7040f00cc665efbb3857f95de5e6d8af465919bde318"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "226829ed045369ff7f0545a4002210b00b655f26e8f5c5474b6156aeb8f6697f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98934e31d8430c5a74aafa3a9af5c9bc915953d2e62bf6d0fa893ec9e03718ff"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
