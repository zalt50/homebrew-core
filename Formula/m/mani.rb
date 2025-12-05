class Mani < Formula
  desc "CLI tool to help you manage repositories"
  homepage "https://manicli.com"
  url "https://github.com/alajmo/mani/archive/refs/tags/v0.31.2.tar.gz"
  sha256 "fdcf1b91ee8fb9403c9d70ae6703af05961df7b4daf906dee667ae31a6ee6925"
  license "MIT"
  head "https://github.com/alajmo/mani.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6309e73f757837509e6794c5194c5fef0a09e8bc868d740202c1f8dcc04e606f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6309e73f757837509e6794c5194c5fef0a09e8bc868d740202c1f8dcc04e606f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6309e73f757837509e6794c5194c5fef0a09e8bc868d740202c1f8dcc04e606f"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd19a923cf7d2743e7102b003d0e35fd8d9f97411d9f8f7a8a6604038dd76c83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4928a33a3c2bfdb7ac81528e105f8b741e9d35539fe30007e4d1a46baeb3b223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0ccc2876c1c95538c304fd9fd487842ef9b616f462c3e7dd788fa2c751a3f75"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alajmo/mani/cmd.version=#{version}
      -X github.com/alajmo/mani/core/tui.version=#{version}
      -X github.com/alajmo/mani/cmd.commit=#{tap.user}
      -X github.com/alajmo/mani/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "netgo")
    generate_completions_from_executable(bin/"mani", "completion")
    system bin/"mani", "gen"
    man1.install "mani.1"
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/mani --version")

    (testpath/"mani.yaml").write <<~YAML
      projects:
        mani:
          url: https://github.com/alajmo/mani.git
          desc: CLI tool to help you manage repositories
          tags: [cli, git]

      tasks:
        git-status:
          desc: Show working tree status
          cmd: git status
    YAML

    system bin/"mani", "sync"
    assert_match "On branch main", shell_output("#{bin}/mani run git-status --tags cli")
  end
end
