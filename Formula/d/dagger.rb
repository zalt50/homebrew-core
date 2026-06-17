class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.21.7.tar.gz"
  sha256 "f6b5e327f0fb51f4b8407a925df1d29b1ac3b1a32ff924c65da17f04176d7f9d"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c42453f14adc241adea1619df19cc0eba6c03e2e8256487df63f6e37b13a577"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c42453f14adc241adea1619df19cc0eba6c03e2e8256487df63f6e37b13a577"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c42453f14adc241adea1619df19cc0eba6c03e2e8256487df63f6e37b13a577"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7d2ff03c2f0f8d7b8fde2cccc8ded55b2a6bdcbcef4f03228625cb35721490e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d263e3d66f9512644141eb17dedddfcc6af54fe6e1b33471abd8e5afc2c8b479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d53541ed3fcb754d77e94e5cd7e828d92134d736095d9dd6f3acc9ba906f6af4"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
      -X github.com/dagger/dagger/engine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "failed to connect to the docker API", output
  end
end
