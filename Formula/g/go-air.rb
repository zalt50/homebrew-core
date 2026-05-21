class GoAir < Formula
  desc "Live reload for Go apps"
  homepage "https://github.com/air-verse/air"
  url "https://github.com/air-verse/air/archive/refs/tags/v1.65.3.tar.gz"
  sha256 "35fde02b7cdc39cf3a53e97187e894c443dcdeb1475bc654250cbb5c22428a80"
  license "GPL-3.0-or-later"
  head "https://github.com/air-verse/air.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f1344105d86b5f1ff5a840146880ad6e7f790f2b675974a64285a8fa42936af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f1344105d86b5f1ff5a840146880ad6e7f790f2b675974a64285a8fa42936af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f1344105d86b5f1ff5a840146880ad6e7f790f2b675974a64285a8fa42936af"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcccee25ac42f472541f73b8b47760fc2bb79a03d41f9253e7a9c84533359a49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b6e5bf2bd04c4a1608514d3e049853e3132a3c4a43bc97286028f14abaf34b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5ab75c5d0f98ff2bc7d095830c77ac8e4ecb07ad519b524260a50f751457c2f"
  end

  depends_on "go"

  conflicts_with "air", because: "both install binaries with the same name"

  def install
    ldflags = %W[
      -s -w
      -X main.BuildTimestamp=#{time.iso8601}
      -X main.airVersion=v#{version}
      -X main.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "), output: bin/"air")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/air -v 2>&1")
    (testpath/"air-test").mkpath
    cd testpath/"air-test" do
      system "go", "mod", "init", "air-test"
      system bin/"air", "init"
    end
    assert_path_exists testpath/"air-test/.air.toml"
  end
end
