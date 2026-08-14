class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.119.tar.gz"
  sha256 "563918636a83f977ec6b2ed7e6768f709d7c377a572cb4e8307ad330700f1841"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42da3eec351c67cb7c3544dfb2546471241bfbdaa9f5fa7e12bf8b4cf3ed4fd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42da3eec351c67cb7c3544dfb2546471241bfbdaa9f5fa7e12bf8b4cf3ed4fd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42da3eec351c67cb7c3544dfb2546471241bfbdaa9f5fa7e12bf8b4cf3ed4fd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c472b30c04dca69b1c1ed08a49afec02c9643cdf4ab85875efc3d942a4639a99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6f204a1ac1437ea6fee22e8cff5fed56ef2da7ac23990cdb0cb5a1de6ffac4f"
    sha256 cellar: :any,                 x86_64_linux:  "0308872a7cb79a57400da0302be3cecead423297f354ea7e51616c2c3fe8ee6c"
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
