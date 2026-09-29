class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.21.15.tar.gz"
  sha256 "1f0c6bbe86ecdfd942e7f9ec85baf06cd8eddf4c308fadfcc2e30f7a327c206b"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ac66ff3fa7719bc5528e2ac75f44491ab2a76b7fc2994454e2d35680f63af2d8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ac66ff3fa7719bc5528e2ac75f44491ab2a76b7fc2994454e2d35680f63af2d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ac66ff3fa7719bc5528e2ac75f44491ab2a76b7fc2994454e2d35680f63af2d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fe1354ccd025573cb3007ebbf930f9697639455a64a16172a47e148da29f9f79"
    sha256 cellar: :any,                 x86_64_linux:      "6db3385e0eac83c11458c8693ac23e61cc9e39dc1ad5e455e5b37d8cbd1fe5e8"
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
