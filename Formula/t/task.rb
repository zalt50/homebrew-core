class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v3.5.0/task-3.5.0.tar.gz"
  sha256 "9ea64b411f8314414f440ec765dfdf5a86c9f6159df47e2f60cff3db6b31157a"
  license "MIT"
  compatibility_version 1
  head "https://github.com/GothenburgBitFactory/taskwarrior.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "cc6340ca46a8ccbc3e2c8712e8ef69faa5cdb328b105d84bd605bb956777eafb"
    sha256 arm64_sequoia: "474f4515f109d7ef2b9834d2cebddb06182d3d11c477bae99000d9eb6aa40676"
    sha256 arm64_sonoma:  "de5f379d7cbf9801583a3dd2a66c953925b7ba2f142ac25e1a959847b605238e"
    sha256 sonoma:        "3174738a25b98886b22b14bad71b49fdca9c7d0a13157ff695a3e45f1b8efc23"
    sha256 arm64_linux:   "5dfec83b72433cd1702bf4d9ccae6923547259053d742eb9e954305fea211295"
    sha256 x86_64_linux:  "0391e1e4292445ce5006a922a5b24b0f25aa41844c6b0626e4a6e96e17df5d52"
  end

  depends_on "cmake" => :build
  depends_on "corrosion" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "readline"
    depends_on "util-linux"
  end

  conflicts_with "go-task", because: "both install `task` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DSYSTEM_CORROSION=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install "scripts/bash/task.sh"
    zsh_completion.install "scripts/zsh/_task"
    fish_completion.install "scripts/fish/task.fish"
  end

  test do
    touch testpath/".taskrc"
    system bin/"task", "add", "Write", "a", "test"
    assert_match "Write a test", shell_output("#{bin}/task list")
  end
end
