class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.495.tar.gz"
  sha256 "6c1e5056798dd7c3e31db9b74e99397c7880989eb3095422cc220aec500b317e"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "177cb28e9bcd496c1d4660105df0c37283206f4f6140b1e27ef429f298e6c56f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "177cb28e9bcd496c1d4660105df0c37283206f4f6140b1e27ef429f298e6c56f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "177cb28e9bcd496c1d4660105df0c37283206f4f6140b1e27ef429f298e6c56f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3ceab39d9d6455c3709afd60ad38f69c37be0260fbe52bba85534b5d778fa916"
    sha256 cellar: :any,                 x86_64_linux:      "c997090595093274f1bdf195f2da83cd7741766736a069e4e88af0bea3a16465"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/fabric"
    # Install completions
    bash_completion.install "completions/fabric.bash" => "fabric-ai"
    fish_completion.install "completions/fabric.fish" => "fabric-ai.fish"
    zsh_completion.install "completions/_fabric" => "_fabric-ai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end
