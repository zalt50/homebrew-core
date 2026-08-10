class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.26",
      revision: "b5645422abd93d43890d015f9d4ded37206a3ec2"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df2d906746b013521429390f36fa316d078b1aaf6bcef64627fdd8f7193ad7c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3be675d139dfc3036154988d266e1ff9953e308243e72bff6fe58bf73d76d78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e30423d84165b6114ebaeb34dc87e23ba8de9b0e26475e84c093cfc4930a437"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2b46d59baa84d4c23f3adb0a56a3b76ea74e5feaa01bec390f995806330468c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50e14f348cf9d5cd8424577b4b7901e62faef6e7341e95e1a2fa265b766260f6"
    sha256 cellar: :any,                 x86_64_linux:  "45bcb3d023b2dfc5da974cd187aca68b9c3e1e607d86f8d3a05d2802a3f5ef1a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end
