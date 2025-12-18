class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.46.1.tar.gz"
  sha256 "83f751161e7f47df4e4d4f7fda0217c113bb20c79c8fbb56300f0f9dbfd8581f"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82802ff93126307d8f1d6260786f1e0997b7cf8a1c671a0b62f5339211b91b65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82802ff93126307d8f1d6260786f1e0997b7cf8a1c671a0b62f5339211b91b65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82802ff93126307d8f1d6260786f1e0997b7cf8a1c671a0b62f5339211b91b65"
    sha256 cellar: :any_skip_relocation, sonoma:        "496434d3fae8ba4ae32ab727262cf5106d0593db39bbc205fc1c21f5bbb02cb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e399ee23a178aefdc1cd988f7f51ae16edd8bafce44595ac0fd5d7a0ffeb584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed0fa58398bb82f22a27fe61dfd2384ed4a51882f37f4d4436275b8d15751740"
  end

  depends_on "go" => :build

  conflicts_with "task", because: "both install `task` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/go-task/task/v3/internal/version.version=#{version}
      -X github.com/go-task/task/v3/internal/version.sum=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"task"), "./cmd/task"
    bash_completion.install "completion/bash/task.bash" => "task"
    zsh_completion.install "completion/zsh/_task" => "_task"
    fish_completion.install "completion/fish/task.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/task --version")

    (testpath/"Taskfile.yml").write <<~YAML
      version: '3'

      tasks:
        test:
          cmds:
            - echo 'Testing Taskfile'
    YAML

    output = shell_output("#{bin}/task --silent test")
    assert_match "Testing Taskfile", output
  end
end
