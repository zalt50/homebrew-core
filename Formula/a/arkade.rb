class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.113.tar.gz"
  sha256 "3adf369bf229709255aa5d4a6ff6c2959f4f2eb678e3b93a4cc4471d19de1f2f"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cbc588b202eb1ae88ca38a0709fb53f731b25b3841689a88074fd2b7dc97c60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cbc588b202eb1ae88ca38a0709fb53f731b25b3841689a88074fd2b7dc97c60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cbc588b202eb1ae88ca38a0709fb53f731b25b3841689a88074fd2b7dc97c60"
    sha256 cellar: :any_skip_relocation, sonoma:        "da66a5a389b96750a98210348d660356f6828cbb00781f8c2f14c7b344c8456a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ffafcab752b620a8a706901dda631af6b15d5d95a1260887dac1151e9fd6100"
    sha256 cellar: :any,                 x86_64_linux:  "ee0c0cc71499ea479ea8ad36de641dfcc5a0736cc6b158c82d59249e461f68a6"
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
