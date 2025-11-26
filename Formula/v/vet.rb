class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.12.13.tar.gz"
  sha256 "9cdd8183a1fa3e2b1c5c4f756cfdb525ca2b43126a57f71221d51618d000c84f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bca191cddb116de2801a8a89ff952a3006f5de3c46f1d8da59e0aebd3c5d03a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "074e20136555e3603a82ff415fe56360545c2f76d6cbafec7c546b625f5393c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a79abf7aeaccaf9cbe13239e1f129a21b4d820addf08cf81d802a6d3f889d5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "13ec133f2a051c6d6f4f7f4ac730effa91719621ef466bdded538fdd40c3ccfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4367ee3e6268048c5ed2700698623e6af990343191aea564d17818f1e09e942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24aafe6a5bc38566dec625e48eedd64224ad875e6b28997f05ecd3654dd6d9b3"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
