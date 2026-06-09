class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.702.91.tar.gz"
  sha256 "6f086ac2cb0a5f0b0b861b3d2e17047e9d4abc5aeb6ef16e1abdf12fb69692e7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71de84e26464188afdcc54e2c18baf2660ba73c6d4423352c17e60d383b9f484"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53f222586fa3204bebfd3afde6fae4b0406f02579bf6f908c832f1789f623674"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff41336132a6ce814d51ff18473d00411f6b449315405acf2a416418e375b4bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "54546b8dd6460bc00226cee9797873e261d09f6cd966c41b63e7eea0d97c1d0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b58bcd450cd81df5f630e28e546af14dabbda5034326af1791793d7bc4d6443d"
    sha256 cellar: :any,                 x86_64_linux:  "7ab37550ecafa771cc2b93382e53fdd81954a76956b567015be01a4661830585"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", shell_parameter_format: :cobra)
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
