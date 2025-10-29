class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "ccd47c9d5acfe5f4a4d06e9ef1f6279f7cc6123dc42160de8ac8252805d6ac38"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db17391edc448337e275295cb691a2f01c080ab52304e40b7b1944e62b1c16c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a1449babca09bfa9359353783763acf83fa68ac83d493eddf13bf5dcecefb31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a02c12257421b60cc645feec3e46a0876faa47f55b300090d42984e01ec6b4b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1297b8b5d3b1b719269415919baa1cdd3072b0209279e6ad673e2a1c041ae2e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1a3effc75a6d40894343aa145220319e7a0426ed7d8c668479e93db5686d9ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c345f2df4a5b9d82396ac98133a4bab1ba33d2da5e30b35cea0a0ea0f0a3c50a"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion")
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin/"flow", "cadence", "hello.cdc"
  end
end
