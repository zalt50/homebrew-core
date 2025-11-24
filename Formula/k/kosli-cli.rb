class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.33.tar.gz"
  sha256 "0f7a5566b587ff9d334a3120269a1b8d0b5897868f5c8696f01309e2ef2687eb"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf8e6f1e1e62e22908e4ab950bb44e5488d1857de80b7992681598baa9aa3523"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "077ef3854f2401f23d647f532c97db544c235c3f4fa7dc33949093bb01060ab2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b493c5825a7d281f906d82b01855a9e118989298ae84cfda867ccf5b5714f94"
    sha256 cellar: :any_skip_relocation, sonoma:        "67f5b11f7d8cbfb077cf5958cd5e95e13921ff562cc9847f6c1199d237b5bb81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ef9abfda6047a07cf48204d96adcb4e039436b6f4ca032fc63b13f6d8d401e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "010535b1137af88c089657975fa27b2ef780c2a7bd29d2cac99ccc95f87cbca4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
