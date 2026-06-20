class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://synfinatic.github.io/aws-sso-cli/"
  url "https://github.com/synfinatic/aws-sso-cli/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "51e3679c9807ea510d9f83ca7472b9775c34cb6b6c71d0090e923733370cfcec"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b342b4e3673970716a7540afac586502a7fe2b44448c85f3fa044a7916090c3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54687d969449a937c1f233495ccdbd0a9c315d2989f1995434aab3374747a067"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f0761f22328ef7d0c53f2da4d74d3d7152dc9060b7e0ed3770d3ac5418509d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6698ffd05a2220e1d38dacbd49c66d6bb26822424141dad5b9e8b3f7807a3c6c"
    sha256 cellar: :any,                 arm64_linux:   "2e67e2e288a3f81427a6662d693cd1a7e6c4b27b37b6d6091abc6494f4a5ab5a"
    sha256 cellar: :any,                 x86_64_linux:  "37b4c406022e0e14d31f746f483504dc33f2402948143ba32b63606854a6e884"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Buildinfos=#{time.iso8601}
      -X main.Tag=#{version}
      -X main.CommitID=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"aws-sso"), "./cmd/aws-sso"

    generate_completions_from_executable(bin/"aws-sso", "setup", "completions", "--source",
                                         shell_parameter_format: :arg)
  end

  test do
    assert_match "AWS SSO CLI Version #{version}", shell_output("#{bin}/aws-sso version")
    assert_match "no AWS SSO providers have been configured",
        shell_output("#{bin}/aws-sso --config /dev/null 2>&1", 1)
  end
end
