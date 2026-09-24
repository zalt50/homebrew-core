class SpiffeHelper < Formula
  desc "Tool that can be used to retrieve and manage SVIDs on behalf of a workload"
  homepage "https://github.com/spiffe/spiffe-helper"
  url "https://github.com/spiffe/spiffe-helper/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "f764d5ca5a76294bbaa54ae600970da57e231521debd889e3ae58df78516506d"
  license "Apache-2.0"
  head "https://github.com/spiffe/spiffe-helper.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "18c7eb0639a9c9f0eb597eefbc5310c9ed7ed66ebc98babc4fc084583063473b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "18c7eb0639a9c9f0eb597eefbc5310c9ed7ed66ebc98babc4fc084583063473b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "18c7eb0639a9c9f0eb597eefbc5310c9ed7ed66ebc98babc4fc084583063473b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ba482378cc2b8b0efcdfc2d42cf7bf04c3e128e4f7e4d8e68992694fe7d77ba8"
    sha256 cellar: :any,                 x86_64_linux:      "09e314b30ebfcac674e8022a5fd55d8ea648ae5ab0e92b9bc78110db67e58328"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/spiffe/spiffe-helper/pkg/version.gittag=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/spiffe-helper"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spiffe-helper -version")

    output = shell_output("#{bin}/spiffe-helper 2>&1", 1)
    assert_match "helper.conf: no such file or directory", output
  end
end
