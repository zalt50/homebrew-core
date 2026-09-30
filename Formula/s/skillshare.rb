class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "88ce7ce3c5a7bd41dc6a6cd9a273ce7c22058224bd90dd839f8a9e5e16fd2211"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fe100fa6e4988becd5fd5d3606458034aecc0a9e0138736635093fb6fcdfa2f9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fe100fa6e4988becd5fd5d3606458034aecc0a9e0138736635093fb6fcdfa2f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fe100fa6e4988becd5fd5d3606458034aecc0a9e0138736635093fb6fcdfa2f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e3aa7d7a58332a1649f292bbd48ece5307da6824536ab86b302321b4f4a9df0d"
    sha256 cellar: :any,                 x86_64_linux:      "52be9de8ff63cef26a3d70d565e3d08c43d574f8c61bc7c1b5a59eeecfc5a805"
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
