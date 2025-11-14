class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://docs.projectdiscovery.io/tools/nuclei/overview"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "04b28268734d2525ecf8a333da2362016d614cac62da32ee9b2a3299b1123273"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "971afae549a5111d7bed2dbcb6695969b390b444b3d1b35cfd4bdc8b185a0903"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2b57d637f7da75d9e473ea54cc73cb1a81cbe99d5a61ab7de09a39e4a3893a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3fc71a317eb1c143836f20f868736c722779ab6f5265558af9f88dcc2609564"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9bc78caf525abffdd522c0b7c23207a75429e8c491a796b79d3bfb61328687d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d855a19636d76c392c26a128f64734ce255c5d4cda98529efd1caec85b4e594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96298e47e8d55f791d820b8fb274e027070c4c39dce86f1cd3aa0e28df4d2ec7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end
