class Structurizr < Formula
  desc "Software architecture models as code"
  homepage "https://structurizr.com/"
  url "https://github.com/structurizr/structurizr/archive/refs/tags/v2026.03.06.tar.gz"
  sha256 "5b47d506ff4735bd2d52d5aedb546e1711a50c9042f6bfdc02e3f5dc2d1f91e8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9874f2ea1e0eb812097c01376356249151aa07d4a960e92ff1e63e16655ca2fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cf21b678479096eab189a6ebbf364fb991cb280b522faeb6b9f44ea5de79e2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f045fc93055d91fe2e26a6f16a0fd27f5ae1b34417eb86e84cc93d4daf2da5bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "74dee786fc1184e6edd587e2579631029a06c5d4a8b03674f7ee4c95d15a59f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44a707e0aacea0c79d59783c1e1f676286295c78186a74898832683e066c1b4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9e52e624711b7abdff329502daea45b79b17f4f960ef65502f4613614873bdd"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    system "mvn", "-Dapp.revision=#{version}", "-Dmaven.test.skip=true", "package"
    libexec.install "structurizr-application/target/structurizr-#{version}.war"
    libexec.install "structurizr-mcp/target/structurizr-mcp-#{version}.war"
    bin.write_jar_script libexec/"structurizr-#{version}.war", "structurizr"
    bin.write_jar_script libexec/"structurizr-mcp-#{version}.war", "structurizr-mcp"
    # NOTE: excluding structurizr-themes due to unknown license for PNG files
  end

  test do
    result = shell_output("#{bin}/structurizr validate -w /dev/null", 1)
    assert_match "/dev/null is not a JSON or DSL file", result

    assert_match "structurizr: #{version}", shell_output("#{bin}/structurizr version")
  end
end
