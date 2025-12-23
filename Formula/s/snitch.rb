class Snitch < Formula
  desc "Prettier way to inspect network connections"
  homepage "https://github.com/karol-broda/snitch"
  url "https://github.com/karol-broda/snitch/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "308d7f5a91deb55feaf525bc2d8e02c04f9717090a17b1ac14a275c0363e3f2d"
  license "MIT"
  head "https://github.com/karol-broda/snitch.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X snitch/cmd.Version=#{version} -X snitch/cmd.Commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"snitch", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snitch version")

    assert_match "TOTAL CONNECTIONS", shell_output("#{bin}/snitch stats")
  end
end
