class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://github.com/launchdarkly/ldcli/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "61312e0128c763714739adae7d5d0e3e24e7d818cc0f74a126a898d019ffe3ac"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03b140d1f75dd7554a853858002578146efdd66e2272967e141d389f053b31fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d22b1beb8e09ca9907c0ca9a9ef6600715f090485f91beebab9b4d950cf9c26a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "512e805265e4662cd2a76492a2be6fc3dd22dae22b1036b0f58131acdb2feb64"
    sha256 cellar: :any_skip_relocation, sonoma:        "4468bf0b1570a3b1e60321ea12e1b7c9d1d2b4995c2d6074f4f8dcb22d6e589f"
    sha256 cellar: :any,                 arm64_linux:   "9f1a2a0124abb43217f2671bfb105a10a6bc0f3bb8353bc76435bc02d435288f"
    sha256 cellar: :any,                 x86_64_linux:  "9701129374b8985332ed8225aa53281a113168280dfb122972f065d72898a695"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"ldcli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    output = shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1", 1)
    assert_match "Invalid account ID header", output
  end
end
