class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "74016623d2f09661763717e9f77d9ff28107257a118325c8a30280c4886c3dbf"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "107795f8f5646cd4890b6a1df9f83c55e99df91c676f4319637c6fb144c7ac49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "107795f8f5646cd4890b6a1df9f83c55e99df91c676f4319637c6fb144c7ac49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "107795f8f5646cd4890b6a1df9f83c55e99df91c676f4319637c6fb144c7ac49"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c2a8f4278c4f4b6f7d2495c803241715b7d1402793da64475d8f333a6b6a7b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7829a317c6f53da633844bd7ad586a5dffb3973c86fd745cb24817be72303eef"
    sha256 cellar: :any,                 x86_64_linux:  "c825d2dc224d3026cc16147b4a635145ac061de1c54bc1196f2603e3ce57c4aa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"force")

    generate_completions_from_executable(bin/"force", shell_parameter_format: :cobra)
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
