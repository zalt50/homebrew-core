class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.120.tar.gz"
  sha256 "f1edec0af8b2dcd0d988c1a0237c38c73082ed0e2948f96433471c5572782703"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a34a260d88cefeb36f4a0e53f621a324f8833a9c0f17ba6edcd5cb522956f12c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a34a260d88cefeb36f4a0e53f621a324f8833a9c0f17ba6edcd5cb522956f12c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a34a260d88cefeb36f4a0e53f621a324f8833a9c0f17ba6edcd5cb522956f12c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7660f854b9966931959173ec346ae90c6e7f6d4777279c401d739ea1271a755e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ff8aeffec868bb15fbcd79854413f785c79c4ae8b4bb7021b12920f89b4f20a"
    sha256 cellar: :any,                 x86_64_linux:  "82f91ef597ab891b57e1e61c8805f7f0b0b4129b00a64daf41ed8afc326a8ce9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
