class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.47.1.tar.gz"
  sha256 "ed02902872cb56b656fb5517c0bd9ec4229e9bc2ac7e84f23a5861fc1902a56e"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1a77fde7b4261b1d8a91299885efe93c3af825ed9bcc29a92a8a0858af02e73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81233352a2f660fd30a59109573a8aacf5678120a6731986584a8163c7144801"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8be1bb19b09b0025e1f3b6be833e51958c9bcd449e46de9cd0950d7df898c9e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "68ef76475dd22f0d81b5a1f25ef94cad7e54afacdd494273fafada8bda06b35b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6865aed7ef71d417511dd9afcdd32d8033fb8ec21536d352e02f4b52620f2020"
    sha256 cellar: :any,                 x86_64_linux:  "6e1c960fd11aa436f470d5386ae429d944181fe7fc36792a8d9731bf8241f61e"
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
