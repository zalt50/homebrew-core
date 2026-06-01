class Goodls < Formula
  desc "CLI tool to download shared files and folders from Google Drive"
  homepage "https://github.com/tanaikech/goodls"
  url "https://github.com/tanaikech/goodls/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "5acda68a159e8bc7d8dfe164a2bb44a8868240db9394b6c5eff93233260a4b8b"
  license "MIT"
  head "https://github.com/tanaikech/goodls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03ea8da334ab4c08252de8ba618cc62ddfb462e04a0c038c402923d4b2e0c258"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03ea8da334ab4c08252de8ba618cc62ddfb462e04a0c038c402923d4b2e0c258"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03ea8da334ab4c08252de8ba618cc62ddfb462e04a0c038c402923d4b2e0c258"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e03593824cbf3bf4d8039ce3c14f393e9d481ca79f795751cca8918ec1fe283"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82ba5cbf890c88ade56c2de77d1bc673d5aeefed1f069def4758fa8785c38a59"
    sha256 cellar: :any,                 x86_64_linux:  "330e5c6c8e4566781ccf5e3af4d548db544608518c549022c12903d554046461"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/goodls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goodls --version")

    output = shell_output("#{bin}/goodls -u https://drive.google.com/file/d/1dummyURL 2>&1", 1)
    assert_match "URL is wrong", output
  end
end
