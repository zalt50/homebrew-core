class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v8.5.2.tar.gz"
  sha256 "c5cbd0578979b6bf67127140242e8b25b664e7ab84097e6bff5afcb95c824bbf"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7af52d98b2322ecd9aa9bde78f6b9f38acd02af0c1ba43419322d06513164761"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7af52d98b2322ecd9aa9bde78f6b9f38acd02af0c1ba43419322d06513164761"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7af52d98b2322ecd9aa9bde78f6b9f38acd02af0c1ba43419322d06513164761"
    sha256 cellar: :any_skip_relocation, sonoma:        "abf784a9e138955865eef93833acf8536244daca475b6740d525ff63663a90fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "020e86193e704cd44937fa2040372de3ad7c47e48a10b6d303c167268fd0e300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50ba44c5e26e63a82014a38b9a1d23fa9d9464449d3d892585538e44a37c16cc"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
