class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.93.tar.gz"
  sha256 "9b871f190020c92425324371357fe040733bf453a48adc7fe14fe31a9f35133c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "395ef704d6cc7d75ee3c9cce7ecefd19b1494a0fe7f46b1c3e9ea375f780e51a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "395ef704d6cc7d75ee3c9cce7ecefd19b1494a0fe7f46b1c3e9ea375f780e51a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "395ef704d6cc7d75ee3c9cce7ecefd19b1494a0fe7f46b1c3e9ea375f780e51a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5b1a64b099a7eb87c36daea694b8b6210cd3456b11fc28656cf904ae83cfd13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9b676affcd72ffd48343c9e01abb7349e0f68b3074158878e410fd610e17680"
    sha256 cellar: :any,                 x86_64_linux:  "00d60746369e762d93b64769ab4fc763063754d8382c0696c80a9dc0748dc8aa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end
