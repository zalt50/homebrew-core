class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://github.com/wakatara/harsh/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "b2bdb5909e2ddde6086e9349d9cb8c02827f37154f4b903e53b328fb92817bc6"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e25fcefd72bdb33549791a7071e9f38ffdda953e4f447d2a17f075da77ec910"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e25fcefd72bdb33549791a7071e9f38ffdda953e4f447d2a17f075da77ec910"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e25fcefd72bdb33549791a7071e9f38ffdda953e4f447d2a17f075da77ec910"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e99a9cc8e38dae470e28d8e1d9637bd3ed1a77c0028e8491cefed8a8593bc8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de9df101f078eed4523cc31d41169253279483515e1ea5c610b24abb62b9eeb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3030202d71533992e389f9e460b749b1be3622751095bf2f229e1b3ace557ba6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wakatara/harsh/cmd.version=#{version}")
  end

  test do
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
    assert_match version.to_s, shell_output("#{bin}/harsh --version")
  end
end
