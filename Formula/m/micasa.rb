class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.66.0.tar.gz"
  sha256 "354b6bf8d3c64307db64eb0673f206c4dad52f84b8bba42647ca99bb23706a75"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7102804cbe36ac508953e75f12dc9549b92133d7a9dedfc118349a0cb7cf0b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7102804cbe36ac508953e75f12dc9549b92133d7a9dedfc118349a0cb7cf0b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7102804cbe36ac508953e75f12dc9549b92133d7a9dedfc118349a0cb7cf0b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "17907836a2dd2dda85ceda0bb77c26031d7ef9d9a92db2f995e1fb8ed14f1638"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bec3832f9e9ee3e9c4af8634c10fd7c9a82f807c90ae27f22391d67c2b2ac6fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1a4147ce922070b35ba14abfa62fdf5a8eb9877a056c408af06144ef89a0363"
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
