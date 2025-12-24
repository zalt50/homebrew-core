class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "d0930fa6ba78b3941348b6949ee999c3de3ae87f328b7be3a8e40286cf2858bb"
  license "Apache-2.0"
  head "https://github.com/aws-cloudformation/rain.git", branch: "main"

  livecheck do
    formula "rain"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2c61763d2de9bb0dcbbfce237f1ac173dcbd61d7c87064f139fde56011cec14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2c61763d2de9bb0dcbbfce237f1ac173dcbd61d7c87064f139fde56011cec14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2c61763d2de9bb0dcbbfce237f1ac173dcbd61d7c87064f139fde56011cec14"
    sha256 cellar: :any_skip_relocation, sonoma:        "756ded56390fffb191d6b2ad08ae11f5d9a4cbdb108f5e2fa39648f4be0369e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0e5025628d1f41ff08095ad057c4f02feb6b438ace39ef700556b2163a99b4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de1c8bade06cbe0150489b13059561fd9a38c59f543dbe7c3a1da22c5d09c177"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/aws-console"

    generate_completions_from_executable(bin/"aws-console", shell_parameter_format: :cobra)
  end

  test do
    # No other operation is possible without valid AWS credentials configured
    output = shell_output("#{bin}/aws-console 2>&1", 1)
    assert_match "a region was not specified. You can run 'aws configure' or choose a profile with a region", output
  end
end
