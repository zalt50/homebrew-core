class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.10.0",
      revision: "175074f222a2984ec569ab743fd352e6683b27cf"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cd8460a8d758906590371137adbdba66ac6fe597e4b043e89713637c9a09bca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c076a79d8392e14e6a0dfd46a755eb9d51175f64b1e28ef046ac66a76f1d291"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2060156ae5378427f8e33493cb038b8ca301efc7c2247051d456739950a7f5a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f40b8e253953f7a4494d8c2e0c54c3573921fb4d4f93abbcb28d022a7cb9ea3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b695523f1e2e7b13b5e8f9ed30d89ed01bb7f5c04bfeaa34a23302f4254f35a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3422ae1b3a966750710fe40b6c77f04a69437c751fdb0108db554ed7b397c31c"
  end

  depends_on "go" => :build

  def install
    system "make", "clusterawsadm"
    bin.install Dir["bin/*"]

    generate_completions_from_executable(bin/"clusterawsadm", "completion")
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config #{bin}/clusterawsadm resource list --region=us-east-1 2>&1", 1)
    assert_match "Error: required flag(s) \"cluster-name\" not set", output

    assert_match version.to_s, shell_output("#{bin}/clusterawsadm version")
  end
end
