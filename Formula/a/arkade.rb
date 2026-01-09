class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.62.tar.gz"
  sha256 "aef839dc3481d8cdb6d3c7af4547df21266b3357f7d1320750893fb4c7afbc2c"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9699de501e3a92b203c665b6a1ef723df9cb99260942903d65a6d932354ab6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9699de501e3a92b203c665b6a1ef723df9cb99260942903d65a6d932354ab6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9699de501e3a92b203c665b6a1ef723df9cb99260942903d65a6d932354ab6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dde4bd6dde8dda1735cc9e4068bafe9814965459200786116a80e4179c1cf19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee830cb2e8be398d73ffecc1cbe1ef916598d1647e471a25a2f0a4e6e44cac66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63d832a752513ed66015d58cd88be591d3ceec7fde9dacaca27b3b0b00ca2d82"
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
    assert_match "Version: #{version}", shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end
