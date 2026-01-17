class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.22.5.tar.gz"
  sha256 "a18920ce941613a9031df78ef3f29b21c9d3521ce6d700ba03d0f243c6971b21"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1316afc543fc2ca6c6d735bc7c07768fd19bf19c7c93cc3ef9df46bda0d8a2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbc970a4bcfd20b1d89c55bf6c0227d9b5779baa07fac41e6e422b502012fdb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d52137b82ea630a30f71e1ea56bc5a419f585fa5e933374cc1017bac583ad6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5291daa012f9ed18a14af3eab8582a9df62d4158e931a5e661d17187f08803d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b97ea822c395c135ade6597bafb355545a92bd473a09e9c97da57500238b90bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "109cf1bec1f69d8fa275cdefdd6fd23b57ad9cebb40d82b72ba5a43b97b40910"
  end

  depends_on "go" => :build

  def install
    (buildpath/".installed-by.txt").write "brew"

    # Version should be in the format "<version> (commit <commit_hash>)"
    azd_version = "#{version} (commit 0000000000000000000000000000000000000000)"
    ldflags = %W[
      -s -w
      -X "github.com/azure/azure-dev/cli/azd/internal.Version=#{azd_version}"
    ]
    system "go", "build", "-C", "cli/azd", *std_go_args(ldflags:, output: bin/"azd")

    generate_completions_from_executable(bin/"azd", shell_parameter_format: :cobra)
  end

  test do
    ENV["AZURE_DEV_COLLECT_TELEMETRY"] = "no"
    ENV["AZD_DISABLE_PROMPTS"] = "1"
    ENV["AZD_CONFIG_DIR"] = (testpath/"config").to_s

    assert_match version.to_s, shell_output("#{bin}/azd version")

    system bin/"azd", "config", "set", "defaults.location", "eastus"
    assert_match "eastus", shell_output("#{bin}/azd config get defaults.location")

    expected = "Not logged in, run `azd auth login` to login to Azure"
    assert_match expected, shell_output("#{bin}/azd auth login --check-status")
  end
end
