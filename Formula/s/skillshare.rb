class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "6782bc38fa79385112df59f7be25a3676005aac80d5ea2d6af668c2e1a94377c"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "83307c4f5e9b4882e1ec0725be9551a61047ee2a27537adc8a42b19432b3428a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "83307c4f5e9b4882e1ec0725be9551a61047ee2a27537adc8a42b19432b3428a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "83307c4f5e9b4882e1ec0725be9551a61047ee2a27537adc8a42b19432b3428a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e049dd708f3a9113ff1f1f2ac1796d454baa43dabcfcea8e0fd351968702c160"
    sha256 cellar: :any,                 x86_64_linux:      "0099f640d310c6414c8061f9a00c44a9c0756fd785e889423ba5a713da8a357e"
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
