class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.13.4.tar.gz"
  sha256 "1bfbd4c42d4f5c00eea738bf93a1b6d1b90ad6a934af84b775f8aa1bd7381435"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "334cbff336740a29ff925030d86766a9f188e3ad272cc4440b47de73812dca5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd02e6ec3660df263b9826b4a1bff3100fc813d4d774cbd195637b427e353c7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3943f02c565b7306560687b6b874c48d64c9931bcb60480b16f1547e17b656c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "85bddc9e1a03c4d0f6bfcb6748fe5b8d26dcf62f955465789a8de6ade537865d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3fd2c52be4904068655f28e39f190fa77d61fc6e0efbb6947ad4b68043ff5ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "539d7cc51ae74d4618cd6bfaf5feeab619a922a6e4af236a4393888649c42418"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", shell_parameter_format: :cobra)
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
