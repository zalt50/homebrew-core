class KubectlTree < Formula
  desc "Kubectl plugin to browse Kubernetes object hierarchies as a tree"
  homepage "https://github.com/ahmetb/kubectl-tree"
  url "https://github.com/ahmetb/kubectl-tree/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "5b0070fc84fa54e4120a844e26b5de0f5d8a9c1672691588f1fa215f68ba1e5d"
  license "Apache-2.0"
  head "https://github.com/ahmetb/kubectl-tree.git", branch: "master"

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/kubectl-tree"
  end

  test do
    output = shell_output("kubectl tree deployment -A 2>&1", 1)
    assert_match "couldn't get current server API group list", output
  end
end
