class Golines < Formula
  desc "Golang formatter that fixes long lines"
  homepage "https://github.com/golangci/golines"
  url "https://github.com/golangci/golines/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "0dc245339b1508d6489950315d46ac1643a70dce40d172e85b6bd9e6bd6cf6d3"
  license "MIT"
  head "https://github.com/golangci/golines.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a9cd3736e5ea0b6729260f8248667baec0c80eea786497407b7fa78d60c8879"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "710c57a0a2617f276e3a28d562681aee915ed9a07df2c26c75dda51f706a76c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "710c57a0a2617f276e3a28d562681aee915ed9a07df2c26c75dda51f706a76c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "710c57a0a2617f276e3a28d562681aee915ed9a07df2c26c75dda51f706a76c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2ee8ae303535f819313db09acfb54a1cfb649bd9ec3620cf8f9f4a5984fc675"
    sha256 cellar: :any_skip_relocation, ventura:       "e2ee8ae303535f819313db09acfb54a1cfb649bd9ec3620cf8f9f4a5984fc675"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de399995aed9ac22003ca96152ebc08604c49482a6034f509dd7e55e0387af91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e70a09df4e69252b296398c24b6a557c5b16044117eb4d9987ae15c260b7dc57"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/golines --version")

    (testpath/"given.go").write <<~GO
      package main

      var strings = []string{"foo", "bar", "baz"}
    GO

    (testpath/"expected.go").write <<~GO
      package main

      var strings = []string{\n\t"foo",\n\t"bar",\n\t"baz",\n}
    GO

    assert_equal (testpath/"expected.go").read, shell_output("#{bin}/golines --max-len=30 given.go")
  end
end
