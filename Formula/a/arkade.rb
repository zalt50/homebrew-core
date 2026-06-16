class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.100.tar.gz"
  sha256 "9975594eb52fea701f25bf7e4e5d63d9fede4697c255ce5d37e423454eb0201a"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e919976d772ac329895c9a87364b71661f193569078924348c8787e7b2ff6744"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e919976d772ac329895c9a87364b71661f193569078924348c8787e7b2ff6744"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e919976d772ac329895c9a87364b71661f193569078924348c8787e7b2ff6744"
    sha256 cellar: :any_skip_relocation, sonoma:        "586034f33b6e70b4835396e46ab0e85d9269684771c3c333958cbd5564f3c68a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb8aabff9de7815cedb1921f0289baa0a99c3a07ef0b7a84132b062e058b58de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c8ef8ce0823c6071a7419b41a0478d67f405245defd781173cd7e526a8a8f57"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", shell_parameter_format: :cobra)
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end
