class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.19.16.tar.gz"
  sha256 "03df73a59a441d53df5262c8d3d3d8783833e5f2c22a4c8001f784ceaf6b16ef"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7f004a3cc86a50f6ea9b564f2f89dc2e81347816099eab7d37150459a19aa20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7f004a3cc86a50f6ea9b564f2f89dc2e81347816099eab7d37150459a19aa20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7f004a3cc86a50f6ea9b564f2f89dc2e81347816099eab7d37150459a19aa20"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5fb3b9aded89d406986979ccd0a75e651b249ddbc5e4187432fdf04f9795b9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c797cd1523282479bef6ecb25e17423e0f82f6b0b1e6398025a8df900ffa796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4fc21aef24a9fe079e55b324838a7c505bedea26bec5a60697a8b218726b8b4"
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
