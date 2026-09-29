class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagucloud/dagu/archive/refs/tags/v2.18.1.tar.gz"
  sha256 "e1e48f714d0708a89afde4e288fdf87fa1521614ea8ffb7fb4d9c74dc3a5313e"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d89afa43a5c1a24dc8962886971dce6e6bbbf67daf38cd077bae6c38c0f86f83"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d269bed5a4f1a23e45e3011d12bc37d49e23e5730915b6c48841241d7db81855"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b39d20ab9428b59c60fff10d06c3ae65413b57ee786ad33ad924ee5b4e07e024"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "52988985ad8972c05cc3cbee1d6958c83fd5b422d4e3e8b3a6f2352c30f8000d"
    sha256 cellar: :any,                 x86_64_linux:      "3a835c4431db8bef75d1daa868a88f7cf1865fe19ff25005f2500f54f3b6fbec"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "ui", "install", "--frozen-lockfile", "--ignore-scripts"
    system "pnpm", "with", "current", "--dir", "ui", "run", "build"
    (buildpath/"internal/service/frontend/assets").install (buildpath/"ui/dist").children

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd"
    generate_completions_from_executable(bin/"dagu", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"dagu", "start-all"]
    keep_alive true
    error_log_path var/"log/dagu.log"
    log_path var/"log/dagu.log"
    working_dir var
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dagu version 2>&1")

    (testpath/"hello.yaml").write <<~YAML
      steps:
        - name: hello
          command: echo "Hello from Dagu!"

        - name: world
          command: echo "Running step 2"
    YAML

    system bin/"dagu", "start", "hello.yaml"
    shell_output = shell_output("#{bin}/dagu status hello.yaml")
    assert_match "Result: Succeeded", shell_output
  end
end
