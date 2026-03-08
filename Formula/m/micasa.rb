class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.76.2.tar.gz"
  sha256 "c7d54c9d34d6998272bbe763ae4c44ad9979d779029472601f92624b3bb42dfe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "497129986bc5499abbfb40c52a0ea63e1c124f6c34ade7507e75e910082c8087"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "497129986bc5499abbfb40c52a0ea63e1c124f6c34ade7507e75e910082c8087"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "497129986bc5499abbfb40c52a0ea63e1c124f6c34ade7507e75e910082c8087"
    sha256 cellar: :any_skip_relocation, sonoma:        "267ec0336189ff2459383bcc83134978145302768e63e787bf5723ef2d5edfc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba1fd41dde0a488020aa72328e980ac3ea46e1717f33b774d828a49b4810a1b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0964c96abc9d52301de7c5fdcf69c7165088081d2403fb92a59b302b5598887b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    # The program is a TUI so we need to spawn it and close the process after it creates the database file.
    pid = spawn(bin/"micasa", "--demo", testpath/"demo.db")
    sleep 3
    Process.kill("TERM", pid)
    Process.wait(pid)

    assert_path_exists testpath/"demo.db"
  end
end
