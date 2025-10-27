class Ov < Formula
  desc "Feature-rich terminal-based text viewer"
  homepage "https://noborus.github.io/ov/"
  url "https://github.com/noborus/ov/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "bffde991c53478d8aaeb871f30c21d50cbd4426432666bd95d0978df03f54229"
  license "MIT"
  head "https://github.com/noborus/ov.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b4bdc2761aeb2e736d572fdf1fa29fd9b4491364d0e22e2e2fd380415ea3f15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b4bdc2761aeb2e736d572fdf1fa29fd9b4491364d0e22e2e2fd380415ea3f15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b4bdc2761aeb2e736d572fdf1fa29fd9b4491364d0e22e2e2fd380415ea3f15"
    sha256 cellar: :any_skip_relocation, sonoma:        "42b9f2c4ccad56f26a8af98a51ec509a047012d1fbec7880ddba19d93922f66b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a139cc51f7510d98c8e1ec34b6282f3d9533728343a19ea3d9efc893683e5f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20521e472b01271a6a83ed9e231690b2f2d3e3f19fbe09d355547379cbc2610a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ov", "--completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ov --version")

    (testpath/"test.txt").write("Hello, world!")
    assert_match "Hello, world!", shell_output("#{bin}/ov test.txt")
  end
end
