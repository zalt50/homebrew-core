class Gof5 < Formula
  desc "F5 BIG-IP VPN client"
  homepage "https://github.com/kayrus/gof5"
  url "https://github.com/kayrus/gof5/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "33356f098a81b4ffa17eb63b440675a920a8cb0319b5f3285985b58f88973fed"
  license "Apache-2.0"
  head "https://github.com/kayrus/gof5.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/gof5"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gof5 --version")

    output = shell_output("#{bin}/gof5 --profile-index=-1 2>&1", 1)
    assert_match "profile-index cannot be negative", output
  end
end
