class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "2aadc52c2883b7b0d2e33468b28f94232ce1d0688b96fcb7e4b926841f157b88"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc4298413e5174a5c9f7cfec0440f4493890f32f8338e621f08667d85403f742"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfde28f8e79a3ee9d18bea094718b12ddee502f3a5aa41057d581ac75a80bec7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d66934aa6f72ddcb88dd6eb9329f1e8e5c18534bba3706bef3669ed9463d7dd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5d44fddad677380abd19faee06dbcc59f524c56a2bdd9d1d6dcdc8d350f1189"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4210002f9276a7acb857e3d661a37d822269d30c3e9cd34f372ab888132148fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4298a5cadc2b13c84466969fd60128d1c8e78a02e26150afebe4c959c5ca00c0"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/janosmiko/lfk/internal/version.Version=#{version}
      -X github.com/janosmiko/lfk/internal/version.BuildDate=#{Time.now.utc.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # This program is TUI-only
    assert_match version.to_s, shell_output("#{bin}/lfk version")
  end
end
