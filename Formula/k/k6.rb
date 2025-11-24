class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "1f653584c4b8a191474a55a8f2a1ae661b82c6e7e90e243cf27969eb21ee8453"
  license "AGPL-3.0-or-later"
  head "https://github.com/grafana/k6.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d898f3a8734474236cc1e14f94c59dd9fb3978aef62d1a2d029db56a385348de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d898f3a8734474236cc1e14f94c59dd9fb3978aef62d1a2d029db56a385348de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d898f3a8734474236cc1e14f94c59dd9fb3978aef62d1a2d029db56a385348de"
    sha256 cellar: :any_skip_relocation, sonoma:        "cff1dc896a595fde98bf7a93b2edc33f003b5ecb1825abd01cc32c50c785ef18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d00b44f6011a7d3f1d3cbf61f6e9003dd2101848d39659f7b00d7cfd5e42c01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c96c3891f9b96172d409b3f361c9cb5253cf1dceb58d76dbda8d5692264bf89c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"k6", "completion")
  end

  test do
    (testpath/"whatever.js").write <<~JS
      export default function() {
        console.log("whatever");
      }
    JS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")

    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
