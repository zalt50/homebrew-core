class Vibecheck < Formula
  desc "AI-powered git commit assistant written in Go"
  homepage "https://github.com/rshdhere/vibecheck"
  url "https://github.com/rshdhere/vibecheck/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "d8a2cc26fa1db2cc957adc217a1530054f2472dad5f693c83cd86b88ac5ee0e4"
  license "MIT"
  head "https://github.com/rshdhere/vibecheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e33813ef2357efe125fa9a5a487a63755538370fd7a68a168da4a59e9d2f39d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e33813ef2357efe125fa9a5a487a63755538370fd7a68a168da4a59e9d2f39d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e33813ef2357efe125fa9a5a487a63755538370fd7a68a168da4a59e9d2f39d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e281e888bc134fab3dd7b3e79730171a95c7a2288b166384e0e701c45937129"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc0b9f1b15faf9e62081ff581053f7e8624411ae959148cc662e7a8011041072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ef5c72eb70844b5b5eaf9b59907e2b406e6e2d9d77f756fc33020ddc8de0957"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/rshdhere/vibecheck/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vibecheck", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vibecheck --version")
    assert_match "vibecheck self-test OK", shell_output("#{bin}/vibecheck doctor")
  end
end
