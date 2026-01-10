class Dstask < Formula
  desc "Git-powered personal task tracker"
  homepage "https://github.com/naggie/dstask"
  url "https://github.com/naggie/dstask/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "afca526d049874e2609d91c0e5f186d614c684ec13b2fe517e00ec4eeb4f70da"
  license "MIT"
  head "https://github.com/naggie/dstask.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d379782fdfe58917c3d3310212d98e545f755b8b683ba8e95b351bcabd8af2ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d379782fdfe58917c3d3310212d98e545f755b8b683ba8e95b351bcabd8af2ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d379782fdfe58917c3d3310212d98e545f755b8b683ba8e95b351bcabd8af2ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "94159ed9d40ad3a46383decca4b4c8bba53e403cb66b714a01e852e69d722ffe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1b50f896d950aa96139cb7a0daf9bf8d84257fb49e40e457d5727910a7eefe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e79b38c96912b93fb54858df0b845cd5c6fbbda269e7da398218492081eb1b6f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/naggie/dstask.GIT_COMMIT=#{tap.user}
      -X github.com/naggie/dstask.VERSION=#{version}
      -X github.com/naggie/dstask.BUILD_DATE=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dstask"
    system "go", "build", *std_go_args(ldflags:, output: bin/"dstask-import"), "./cmd/dstask-import"

    bash_completion.install "completions/bash.sh" => "dstask"
    fish_completion.install "completions/completions.fish" => "dstask.fish"
    zsh_completion.install "completions/zsh.sh" => "_dstask"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dstask version")

    mkdir ".dstask" do
      system "git", "init"
      system "git", "config", "user.name", "BrewTestBot"
      system "git", "config", "user.email", "BrewTestBot@test.com"
    end

    system bin/"dstask", "add", "Brew the brew"
    system bin/"dstask", "start", "1"
    assert_match "Brew the brew", shell_output("#{bin}/dstask show-active")
    system bin/"dstask", "done", "1"
  end
end
