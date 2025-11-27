class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://github.com/wakatara/harsh/archive/refs/tags/0.12.1.tar.gz"
  sha256 "dc2242cd816e367698825956d15503ee54f8e785c52b7af49725fb548864fbd4"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0610fcaabd11f08004ba5c055d4cde0565b3b564871dffbd60d6d870d0b89df2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0610fcaabd11f08004ba5c055d4cde0565b3b564871dffbd60d6d870d0b89df2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0610fcaabd11f08004ba5c055d4cde0565b3b564871dffbd60d6d870d0b89df2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c27110e1efae105e224c05d422b2ed2ff99ade1d11aad30152b050921885589"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "030d2860e48d40ef63ab7b0ba22dc02c2e10dcb0af96efcd0dc09057bc93157d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d3af13a451c479bdead21ffd2b206ffc034a046e1d2ce147523a9fd63ef98c5"
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
