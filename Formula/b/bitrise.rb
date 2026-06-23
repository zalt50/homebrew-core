class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.40.7.tar.gz"
  sha256 "c097b9c764db3fea347b14d0f02ee9df66b5680e7b8f618261d8409252aee21c"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f89d0e58467b78384e0de333b98a26f87916f0a422d623176fe7a7f874788829"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f89d0e58467b78384e0de333b98a26f87916f0a422d623176fe7a7f874788829"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f89d0e58467b78384e0de333b98a26f87916f0a422d623176fe7a7f874788829"
    sha256 cellar: :any_skip_relocation, sonoma:        "027e000d15dd0fef2af8e10df1d1973946a2739d83fe2cec3c97c062c7fb483a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de65cb1d0251af659941718e1581b0b7229cb16bed8dc96526dc4e6d9fa99422"
    sha256 cellar: :any,                 x86_64_linux:  "e2dcd648273fb75aa800faec35ef1cb4f11e55837d486486dc7b29abd6ca7b81"
  end

  depends_on "go" => [:build, :test]

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/v#{version.major}/version.VERSION=#{version}
      -X github.com/bitrise-io/bitrise/v#{version.major}/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bitrise --version")

    (testpath/"bitrise.yml").write <<~YAML
      format_version: 1.3.1
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    YAML

    system bin/"bitrise", "setup"
    system bin/"bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
