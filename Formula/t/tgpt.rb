class Tgpt < Formula
  desc "AI Chatbots in terminal without needing API keys"
  homepage "https://github.com/aandrew-me/tgpt"
  url "https://github.com/aandrew-me/tgpt/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "9c6d2e0a7540d24a1f94b9e9ee8b55db4971b5723aec4cfe79a77b46885b4ac5"
  license "GPL-3.0-only"
  head "https://github.com/aandrew-me/tgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f170adfc7e221f022662f3890ce7c4e65096a54e89f0e299154a17783ee0666"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3447294392f618efd80f2d311c29cf4a886e31809d1444e60ded6ae2ad153a73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9ed0c74f7448afc363ad31c9c12acc7ac39210d70638b93c025319a55c457f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e53e5ff3d4f95e69cae009c4d8bbfad4b7bc4962146bddd153fea7f49883010a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b806032f331d56a4f7cdf09d9dff1b84940f5f03537e73270ba6519814a55e5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9f5022eceab6be3bfdd87b0a5784b1df7b52de614ce3f78472631fa0f4ba2e0"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "libx11"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tgpt --version")

    output = shell_output("#{bin}/tgpt \"What is 1+1\"")
    assert_match("2", output.strip)
  end
end
