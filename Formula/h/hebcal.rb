class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/refs/tags/v5.12.0.tar.gz"
  sha256 "ab7e1f76b212b679ceeb0b1b74b30e98019691072ec69b57f927a4c1b911bb45"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e1bae2b02eb3e6cf27e189114d017c17e9d74dbb63d571cd9fa066b0ed6b9ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e1bae2b02eb3e6cf27e189114d017c17e9d74dbb63d571cd9fa066b0ed6b9ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e1bae2b02eb3e6cf27e189114d017c17e9d74dbb63d571cd9fa066b0ed6b9ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7d1ac7be60c339e9c1f0a8d6848500a52ed6aae8973682a6564724261c7a068"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddc3defd93f2deb0917f7a55e1ef996a09711ee1c613e784c114f870870fb016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a03b9d534f552029761432a217ebe53285eef5a14f2b36fcf6967e65558d7edd"
  end

  depends_on "go" => :build

  def install
    # populate DEFAULT_CITY variable
    system "make", "dcity.go", "man"
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "hebcal.1"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
