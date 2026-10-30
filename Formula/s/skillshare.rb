class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "32eb63c9699b8249a81bcf27e68f05ea1cb6d7e65f6f5f225439c3da351b5e01"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5d343d620fd5f32f7a9f1b4a372d8afb1e8e096e47c75130c725422da9b8e5a5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5d343d620fd5f32f7a9f1b4a372d8afb1e8e096e47c75130c725422da9b8e5a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5d343d620fd5f32f7a9f1b4a372d8afb1e8e096e47c75130c725422da9b8e5a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "99e84c3f2574b0a5e7897641a80e01fcc7fb4894a37ddb1d3d0cac303df8c7f9"
    sha256 cellar: :any,                 x86_64_linux:      "0836e2b49c67fbeda47ad9802c82414a8157163986e8301d4c849808708c6a75"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
