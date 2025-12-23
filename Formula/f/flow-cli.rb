class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/2.13.2.tar.gz"
  sha256 "2906c00f8c10867bcdc2fff8e153a3f08be3d394c24dd9c91ed97bc95e983b5f"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3c5752e8e68c0377bc1bfe768d35878a823b6606f1d74c311ff6c981f875752"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e82d877ceb39b1e360b8c3c6ce285ddc0a98e11c9795295cca8bd89c47908311"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f69090c2d43db0a8af14597193567d9857d955b195eb55fc1cf3b74d3a4d9fbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "dde81a7abf82090a04b4c8eb6c05e667772090927cf230e3cfba1188b17da159"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c0d65be5060c0766f73cdc332d21f07c8c56270818b19fd801063b46a39afcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e119c6a473d6ba18d87947e8f838ad8d135a6055648b82ee27e70a7a378dc21"
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
