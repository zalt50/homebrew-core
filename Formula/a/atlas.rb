class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "06c0d2488147466d88aaf14d7ecd6ea9f7f94763cfa45b88689d299b9a496e1b"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acc4e7dc0dd8afc3d07f1d037759902f23c8b29572c824f3e22a6aaf31ecc67b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "391d1a9ef7903b398c7bf9668a96d519581023df3c1d0a8082953f74dc7e7b18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46ebe99c6186195460cb0c765bc7b004a46c65290370169ecc98155d852cbe91"
    sha256 cellar: :any_skip_relocation, sonoma:        "384d4d3c0985caf2ece9ae68188c999f325343ef001264e031d6bee10c230f6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d39ac4e581d2115434a67c570bb724015465edf1727f959f8a8a6bf99431eed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a17aa5bdf705c8fe6361e2ec073f2c25cc44d42fe36debf6a4f5cad89e376e9c"
  end

  depends_on "go" => :build

  conflicts_with "mongodb-atlas-cli", "nim", because: "both install `atlas` executable"

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"atlas", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
