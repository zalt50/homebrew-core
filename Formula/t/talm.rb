class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://github.com/cozystack/talm/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "17191af770ec13593675208ecb07b8443d41f95b112fd8000b7e85df61410ec6"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match "talm version #{version}", shell_output("#{bin}/talm --version")
    system bin/"talm", "init", "--preset", "generic"
    assert_path_exists testpath/"Chart.yaml"
  end
end
