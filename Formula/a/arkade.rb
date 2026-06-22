class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.101.tar.gz"
  sha256 "16ec0eaf545ee37dd3b9aa9d1de1b79213204e2161145e7157871af70a49a0dc"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68c32b4da5fd53abb28440c86947bd7e1bfe962f2fde64a7f2263ce010c8df1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68c32b4da5fd53abb28440c86947bd7e1bfe962f2fde64a7f2263ce010c8df1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68c32b4da5fd53abb28440c86947bd7e1bfe962f2fde64a7f2263ce010c8df1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2db656b96135acfd51bbc25af80f4f08ab659b5457fe2452a0b6716c57978504"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc34b97733de8687ef923a61f47ec8edbdf342a64acf678bfba4af84b6440699"
    sha256 cellar: :any,                 x86_64_linux:  "a83a7e172f821820f0830b354e6d64cc6924ea2e82618eb70f44ba1fdf93b356"
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
