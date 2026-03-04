class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.63.0.tar.gz"
  sha256 "df39d6dc91fbfdb8e6ad11c09bbf432a2e6dd55fd1d40bdeff20cdfafd598d20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f095228a41a3eb61d43d7b6f704737f93e60bfda5d12c348ae8ff918bb32cb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f095228a41a3eb61d43d7b6f704737f93e60bfda5d12c348ae8ff918bb32cb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f095228a41a3eb61d43d7b6f704737f93e60bfda5d12c348ae8ff918bb32cb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f70b3e700c60e7c58d2dcafcd9876275630e501516bd73a13eb754e1ea2655e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f1fafccebebaa3bfdd49ba4ad5c184a677ec6fd2fcecb1e8d4b78aa3a490612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f074bc028fc6bff253aa03609eec9ae1cac6482a94f45b2317e27c73c064f36"
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
