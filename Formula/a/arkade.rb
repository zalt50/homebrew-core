class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.107.tar.gz"
  sha256 "42c203605e869b5c6706992bf15128636f642dab1f134017bd8b9010675e5080"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e738a88d87a8df32136b4d381e0c7e359c5f1577481ff401dd1c0098cc919b1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e738a88d87a8df32136b4d381e0c7e359c5f1577481ff401dd1c0098cc919b1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e738a88d87a8df32136b4d381e0c7e359c5f1577481ff401dd1c0098cc919b1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "44903f7f6b2c07d962fdebad459b4649fdda4aacc0bf74de85b0846e18a08396"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c3ce705c13790fc958661b548f4a5604961c849cfbad7fbb800a4e6faed46d4"
    sha256 cellar: :any,                 x86_64_linux:  "70918c98a8b91bdac219693312a7ac3e96cac474177b5b87d653f7b8f4b99b26"
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
