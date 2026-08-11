class Fluxcd < Formula
  desc "Open and extensible continuous delivery solution for Kubernetes"
  homepage "https://fluxcd.io"
  url "https://github.com/fluxcd/flux2/archive/refs/tags/v2.9.4.tar.gz"
  sha256 "123a43ba4dc80e338064ccf39ce8ee011fae0c3f140bde4fcd90b722e557eef2"
  license "Apache-2.0"

  depends_on "go" => :build
  depends_on "kustomize" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/flux"
    generate_completions_from_executable(bin/"flux", "completion")
  end

  test do
    assert_match "connection refused",
      shell_output("#{bin}/flux reconcile source git test 2>&1", 1)
  end
end
