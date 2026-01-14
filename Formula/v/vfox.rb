class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.dev/"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "0318b8a3de483004d30ab1fb4634a2bd98d2e92c42baee90394965e6fbca4eb1"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "836c99266cb692e0f05ffa779bc1e1bfa223d0af4c49751cb27761ccda6a00f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3151e469dde8abb82a333fbafabe266cbe8286b957be13576a5f8e1dbb525bc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdf392aa82d777925c705d14715dddc409b345648f2b188d5ca0bdc644ad7c6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "49fbf1c53e127b0f425e6a17198d4497914be7fc5e892ca70ff9096ad073d007"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4539a89ea0ad6ea4a776e587bb1c2cf246e5df76c52a68aace47223cf30b883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e16e33609336ba573f8b862594a5028e01d49d7a2303a94b20bda92aba209a7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "completions/bash_autocomplete" => "vfox"
    zsh_completion.install "completions/zsh_autocomplete" => "_vfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vfox --version")

    system bin/"vfox", "add", "golang"
    output = shell_output("#{bin}/vfox info golang")
    assert_match "Golang plugin, https://go.dev/dl/", output
  end
end
