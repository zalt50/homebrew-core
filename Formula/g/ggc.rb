class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v8.6.5.tar.gz"
  sha256 "6dc136e8abb48758d3f64917a18c85025ce1362f315efd1b7dcfd99a2f3589f3"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96e06a675d7b3d008ffb38b9f5643315c1e5514e09bcbe3ee414d3d6deb07ac8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96e06a675d7b3d008ffb38b9f5643315c1e5514e09bcbe3ee414d3d6deb07ac8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96e06a675d7b3d008ffb38b9f5643315c1e5514e09bcbe3ee414d3d6deb07ac8"
    sha256 cellar: :any_skip_relocation, sonoma:        "48ae56d50d68222893ff3c9de76798e0dceaf4515397b288d6f769002a983daa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0933640bccd7cef78eb428d9be07f12313423a064b8f07575da7faf60f76e6b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26b249dd7fd5ed64abac6db9ac69ab1219437a7d2e278c97d3416135c907a677"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
