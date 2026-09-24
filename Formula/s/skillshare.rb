class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.21.8.tar.gz"
  sha256 "6191ca8c4388e130497194408e8c5968184560d3f61b79de36bad535f0843801"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a9fdf55201d5318acca00dbbc5494070df17a807a5631ac20c299e8edfb64fed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a9fdf55201d5318acca00dbbc5494070df17a807a5631ac20c299e8edfb64fed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a9fdf55201d5318acca00dbbc5494070df17a807a5631ac20c299e8edfb64fed"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0a4a83661f820335fd74fad0cf1f6cb5a73780c5d02b12e44cd582774387a9fd"
    sha256 cellar: :any,                 x86_64_linux:      "e09ee3ab697c4ee536003f79d7cce8eea5a81f775b23d53ba53566139de98769"
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
