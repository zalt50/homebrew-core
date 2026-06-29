class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.104.tar.gz"
  sha256 "df017c818e7e65fbebbd446ab4890fd051d10f01d156e25c3c2f97d961b8d188"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "554d8b7b727371119f7759d479f7c5042a666f1b07b54fb2cbc022a5442c5eb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "554d8b7b727371119f7759d479f7c5042a666f1b07b54fb2cbc022a5442c5eb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "554d8b7b727371119f7759d479f7c5042a666f1b07b54fb2cbc022a5442c5eb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "03f5126c489770e0e65cfe74bc1424879824516b5f44a93fbb17a788e0bae898"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "084946e8ebb01cbbb7de9201957c87233bcafa89c8e8358289dad4df7a84ab67"
    sha256 cellar: :any,                 x86_64_linux:  "dc5fbb27894b872517fd5afe10e9f193937096168942268cd9153e300dc10936"
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
