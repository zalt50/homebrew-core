class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.20.12.tar.gz"
  sha256 "53560c620873103632db4502815ef24ce31611a38951ab4b0ca806a1693762b5"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cebe53682e375844a97ec77078e60733995f206063cf6edf393d62b92b529092"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cebe53682e375844a97ec77078e60733995f206063cf6edf393d62b92b529092"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cebe53682e375844a97ec77078e60733995f206063cf6edf393d62b92b529092"
    sha256 cellar: :any_skip_relocation, sonoma:        "3736a50c354fe9345c3698267b1f9ea6f2f99b81139ded6d004b0e2103810c0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1964605f65b8de881d48e697e6c660ada3677f58c2ab3db3009c1482dbcf31dd"
    sha256 cellar: :any,                 x86_64_linux:  "d0fcb0f2c5bdc737490ad8fd9248b1339c7579b048e1cbf28cc8cac032ebabe1"
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
