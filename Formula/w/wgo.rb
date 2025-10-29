class Wgo < Formula
  desc "Watch arbitrary files and respond with arbitrary commands"
  homepage "https://github.com/bokwoon95/wgo"
  url "https://github.com/bokwoon95/wgo/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "c3df4ba1968d36278d6fed223185f6d362b1278d319dab188a23e3c6336c7d05"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "395cb5a0eeaafa8a6ee2b2c9ecd1b5a4ee8b9be6b0618aa3e0cde0d86c34bb8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "395cb5a0eeaafa8a6ee2b2c9ecd1b5a4ee8b9be6b0618aa3e0cde0d86c34bb8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "395cb5a0eeaafa8a6ee2b2c9ecd1b5a4ee8b9be6b0618aa3e0cde0d86c34bb8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8359d00255875e5ec9a248e6775666b34f6a89f883e7062a571286d3ca67a9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bae3cfab9891153f2aa31d0930b95fd9ded449cbf0387e098a70ab3142e143b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d47060c6e8f58748c77440e8ad453ae682bf41b44f1546010853182ef4756250"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/wgo -exit echo testing")
    assert_match "testing", output
  end
end
