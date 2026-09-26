class Kekkai < Formula
  desc "File integrity monitoring tool"
  homepage "https://github.com/catatsuy/kekkai"
  url "https://github.com/catatsuy/kekkai/archive/refs/tags/v0.2.12.tar.gz"
  sha256 "fc9c6e5845b198b465483014ef8b089f6f434ca570e7b72b3fb82e75972c68c7"
  license "MIT"
  head "https://github.com/catatsuy/kekkai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3b69cd9b13628d4cb5a10064ffdb6b8d4bbd7d5419429d21c1e9cc2952ff0fc1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "03dd49cc79a528ac481279deec0b8828d31fbc4dd8cacaccb55fa60f9c4b5939"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "03dd49cc79a528ac481279deec0b8828d31fbc4dd8cacaccb55fa60f9c4b5939"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "03dd49cc79a528ac481279deec0b8828d31fbc4dd8cacaccb55fa60f9c4b5939"
    sha256 cellar: :any_skip_relocation, sonoma:            "64d26a71852fb4ffac1fbd019f8b4d133fd291024b08200321eb8effcf7c8b84"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c3d0e339cd558b6330525812a2bb461a4886250bc8b6a30df33c668c8443290c"
    sha256 cellar: :any,                 x86_64_linux:      "c0a0c03af14935d4c902482cac8b8c63562b3bf504d6f669d6d90317aeffdf0f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/catatsuy/kekkai/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kekkai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kekkai version")

    system bin/"kekkai", "generate", "--output", "kekkai-manifest.json"
    assert_match "files", (testpath/"kekkai-manifest.json").read
  end
end
