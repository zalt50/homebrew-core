class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "a2f5ccf6ca7be527cf510d7b1ef7d7b45a2f487023ded0f3bfc88cf8dbf1cbdb"
  license "AGPL-3.0-or-later"
  head "https://github.com/grafana/k6.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f86cb5aad5aa0b7406c4f4db0a36140a047adf838cef10b7cd4897bf99cedebc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f86cb5aad5aa0b7406c4f4db0a36140a047adf838cef10b7cd4897bf99cedebc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f86cb5aad5aa0b7406c4f4db0a36140a047adf838cef10b7cd4897bf99cedebc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c56d6e521a984911201bc6a720be27c0484a7ca8c0063a486e587fdf4bb053dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64ba80a4a9d90914f3823c9b7beac82b09ae1c5abdfe9cf2623f7e8f91db2ded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24d3c029192b3d1abb05271b2e182075b8e8785422fb37815d78a44abf31844a"
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
