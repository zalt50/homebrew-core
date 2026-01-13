class PolicyEngine < Formula
  desc "Unified Policy Engine"
  homepage "https://github.com/snyk/policy-engine"
  url "https://github.com/snyk/policy-engine/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "847f5d886afe0428602b167cb29922c3be81819151fbbbc154d676e0b33b3714"
  license "Apache-2.0"
  head "https://github.com/snyk/policy-engine.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "768e0365b393a969386e17ecd02ccba675277f6bfe5bfd33f41b9c7e2487791d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "768e0365b393a969386e17ecd02ccba675277f6bfe5bfd33f41b9c7e2487791d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "768e0365b393a969386e17ecd02ccba675277f6bfe5bfd33f41b9c7e2487791d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d709db4976b425f26b94b7642c293fc81e7e61ce2231ea2f01c74329c3446d48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cafe2485ab49a5d760cf260234da92c13f48e0e84975bcf6c3f59c69b740de7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee93b1c06fbee851512e601de08f687b21541384d2d627992a303f0791e6059b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/snyk/policy-engine/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"policy-engine", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/policy-engine version")

    (testpath/"infra/test.tf").write <<~HCL
      resource "aws_s3_bucket" "foo-bucket" {
        region        = "us-east-1"
        bucket        = "test"
        acl           = "public-read"
        force_destroy = true

        versioning {
          enabled = true
        }
      }
    HCL

    assert_match "\"rule_results\": []", shell_output("#{bin}/policy-engine run infra")
  end
end
