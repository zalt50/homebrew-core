class Lazydocker < Formula
  desc "Lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker/archive/refs/tags/v0.24.4.tar.gz"
  sha256 "f8299de3c1a86b81ff70e2ae46859fc83f2b69e324ec5a16dd599e8c49fb4451"
  license "MIT"
  head "https://github.com/jesseduffield/lazydocker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f08ff43b5b54ae4e15ccfe3dc5dbe003f3b2b05b0ba8f648ea672a7485295bae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f08ff43b5b54ae4e15ccfe3dc5dbe003f3b2b05b0ba8f648ea672a7485295bae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f08ff43b5b54ae4e15ccfe3dc5dbe003f3b2b05b0ba8f648ea672a7485295bae"
    sha256 cellar: :any_skip_relocation, sonoma:        "4358fd692caa32ac34dfdaf2162d5a63083064537ead64ba6084bba8ff435874"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "637990e75e234a1873b974e67fa00032c0278202e3fbeb2608d75bf9ecb98b92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08db4039c4df13fc5fb5ac4d048f1ef3703b48a7bb81b6337af91398e7fedc5f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.buildSource=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "language: auto", shell_output("#{bin}/lazydocker --config")
  end
end
