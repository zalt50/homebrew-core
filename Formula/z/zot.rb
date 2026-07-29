class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.25.tar.gz"
  sha256 "4e8c9721537acf84a3500be64c7236d9fdaa350fa9e3312c9edbfee6dbcfc6ea"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "538d3a11d909eac179961986644cb011296e985390a2fb2a6a573183044bcec6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "538d3a11d909eac179961986644cb011296e985390a2fb2a6a573183044bcec6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "538d3a11d909eac179961986644cb011296e985390a2fb2a6a573183044bcec6"
    sha256 cellar: :any_skip_relocation, sonoma:        "10e334d034bcac647fb34da6070d11b751263986963f4240238344765f868b33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d10c4dd83ed41052cb3efa3386598de5a15603336ab355f68a913494d7c9810"
    sha256 cellar: :any,                 x86_64_linux:  "93a9bf72e0095d733e444fb4470f085e91aa8f2e8cccb00a6f22fc4196ed2740"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
