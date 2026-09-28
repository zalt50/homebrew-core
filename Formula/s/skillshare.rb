class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.21.13.tar.gz"
  sha256 "ba92ebcc3c4bb29fce4b520db5352d4c158f2fc70941ed1fbaf5b4983133ede0"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c0ea9aacd16ab5352418920106640eee1e4cb02f327662eb78456d0931fcc28a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c0ea9aacd16ab5352418920106640eee1e4cb02f327662eb78456d0931fcc28a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c0ea9aacd16ab5352418920106640eee1e4cb02f327662eb78456d0931fcc28a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "89499979c0edbc6f648b7a6640ca3234c5b1cd82deb1eb06f9323b091cd8247c"
    sha256 cellar: :any,                 x86_64_linux:      "52ee1866add7053f33754230e2ba29d48d109aa3d111cd8a7ebdb462f66643d1"
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
