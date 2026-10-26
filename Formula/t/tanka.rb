class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "7fcd8c7cd642e08b39f9218c980370e1390837db05ef5f5eb39328830841927d"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "55728d20670b926712805061d8533df7450fb61d68b23d8f4295ab80cfb891a8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "55728d20670b926712805061d8533df7450fb61d68b23d8f4295ab80cfb891a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "55728d20670b926712805061d8533df7450fb61d68b23d8f4295ab80cfb891a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a416752ebb8dee8685136a0051407c83ea143752627a10c260c464c33f6169b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "04eb65fe462035bf8410e7e55cbfa881be375e78856bbf52b7aea0243c0d1817"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[-X github.com/grafana/tanka/pkg/tanka.CurrentVersion=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"tk"), "./cmd/tk"
  end

  test do
    system "git", "clone", "https://github.com/sh0rez/grafana.libsonnet"
    system bin/"tk", "show", "--dangerous-allow-redirect", "grafana.libsonnet/environments/default"
  end
end
