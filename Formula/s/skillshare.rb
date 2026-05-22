class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.19.19.tar.gz"
  sha256 "92bb2b0ab5235372ddae83c8bebe9bda80cc9eac486b1c95581a8426b7b2cfd7"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13c91b3be1cc77e08572f1a3413e32934ece8ba55eea695b2376bd001f122f41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13c91b3be1cc77e08572f1a3413e32934ece8ba55eea695b2376bd001f122f41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13c91b3be1cc77e08572f1a3413e32934ece8ba55eea695b2376bd001f122f41"
    sha256 cellar: :any_skip_relocation, sonoma:        "969abb93b8bc5d510a2ce29712bf588a130ff37fe7fc9cbcf773cc40c57559dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da1c240af230786e3383240e23c98e6b2674139f91cf70ec5b8d58d21830a42d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd60da65aeb25ab0278f90024db720b932808784738972225041e4a8c410fdea"
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
