class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "11f3a2aa54f59b928402e8d5ffc38aacfdad992ee6481f541814af2feeb1d792"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9aa484f8b7da0c2fdaa5957ea7e4aabe232493a88ae1d28031ffd1b495fbd82b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9aa484f8b7da0c2fdaa5957ea7e4aabe232493a88ae1d28031ffd1b495fbd82b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aa484f8b7da0c2fdaa5957ea7e4aabe232493a88ae1d28031ffd1b495fbd82b"
    sha256 cellar: :any_skip_relocation, sonoma:        "99ec282081d462ee592be1b7a9c44cd69883360a685837a59c35abe05b1d76f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3a18fb45f08473242c9cc324245a7565423400bed284c4ef803269208cbab2e"
    sha256 cellar: :any,                 x86_64_linux:  "7073174ced0afb6526a97c91f9136c8aeb0ecad150df0af1b890843bc258ac30"
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
