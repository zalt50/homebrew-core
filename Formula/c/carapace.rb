class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "f29dec6afe57675a01076e94cd3850327b5106b47e557d213958124bc2f3cabb"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "426a821c02241269f46029228d957b5c8f6e6923a6f6d1616d78062281008bbd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c59e2aeefbf4ac44f21f3321d99a025b7e59faf4618df49bb8545e446d4037c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c59e2aeefbf4ac44f21f3321d99a025b7e59faf4618df49bb8545e446d4037c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "c59e2aeefbf4ac44f21f3321d99a025b7e59faf4618df49bb8545e446d4037c5"
    sha256 cellar: :any_skip_relocation, sonoma:            "8ad9b80444652a9f2577217d0311b617664f29967cbf39992f48da7fe057ad66"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "984c4f70c63832197c3b8e636cf73409eef1c01837cafb885287313ac29a3261"
    sha256 cellar: :any,                 x86_64_linux:      "19dd8373d4bc767e738e060a127d0891662d4ffcea59a393e715fc37124e76d4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "generate", "./..."
    ldflags = %W[-X main.version=#{version}]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end
