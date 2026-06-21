class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "cbf6bd96fabc7fdc13252f081df2f7079ed6c3445202ad5e522da664465a3c2e"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39942978cde0321791577aad6f75ca5958687f3d4c4ce8f87be8ef22c6fd2779"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87b9db3e43346226faa787da88691fd16d267b1c0002f2451473e998f01194dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "689a3184231dd581ac30c71c1318daf423f8d7ac09f14255010dcf159e8671b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e4a2d070f59f9286c2f6cb42496e9c49e4e03c80f5e1aeefe6f8663adee4974"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "781b6a59ee60dd58e144c8ce1cf66ddd3e9b027653e04cf093e669317e693150"
    sha256 cellar: :any,                 x86_64_linux:  "5d4343c0fdac155e04b5962ea1f1bb55c1f4746ae665ca8fc1d039e01c63294a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
