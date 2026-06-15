class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.20.16.tar.gz"
  sha256 "c3c9b8023b5440f1c065ab91690316130a23b1af7906ded244a50f2fa5b87612"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32cd3ab86d6d556cbb275a10ce46863ab44d4345cfeb57aed5f8a62fb646bdd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32cd3ab86d6d556cbb275a10ce46863ab44d4345cfeb57aed5f8a62fb646bdd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32cd3ab86d6d556cbb275a10ce46863ab44d4345cfeb57aed5f8a62fb646bdd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "30305ea84d17e20d69dc6d8d58bfeddadddc8fd008df61a40e46e8a49ffcb292"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1afa6b895949bd4ccae1adf88f115cffa16c0d67144cfbac3c80ff99aa4bcd6e"
    sha256 cellar: :any,                 x86_64_linux:  "7472917b2ea01d669716e1b43571a04becc133b40fd056c340a3c21d61999969"
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
