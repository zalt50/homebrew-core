class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "77384da1cc01d66ca48e67febc4953ccf7d10ed9a11d69eae937ebe2533338b2"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "972487c3e5f7705d4fe09f260e3a33d11bbc0f4e3466f2aef974a6f7c6c08b0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "972487c3e5f7705d4fe09f260e3a33d11bbc0f4e3466f2aef974a6f7c6c08b0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "972487c3e5f7705d4fe09f260e3a33d11bbc0f4e3466f2aef974a6f7c6c08b0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "01975f0d9b05d60fa0aef6c4398ee8c14b054ef43f18e35b40b7861c9b61f57b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20de97e39fec7d8494a8b8d97b5db9e23d408d3450fb21a70db0dd8cfe31982b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "994c18a4b371e342fcc61656bb8da6277eeefbb18013e9785c023532e35d18f4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tomwright/dasel/v#{version.major}/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"
  end

  test do
    assert_equal "\"Tom\"", shell_output("echo '{\"name\": \"Tom\"}' | #{bin}/dasel -i json 'name'").chomp
    assert_match version.to_s, shell_output("#{bin}/dasel version")
  end
end
