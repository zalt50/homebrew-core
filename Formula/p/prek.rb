class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "e54262747f00fa09928f985562c55d9b8143b3559493015fa398ffb29a70a3c6"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d813427d686e4dc2897438489f939e647c72173e5062a78f9fc669a0dcb0448a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a1015ce692281c691b2d44897b7f14fdcc3ad1c4c30bf065bbe958a6b659960"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01df7260eabf80528363cd789e075484597c891586a08bd4d0df51d5850608da"
    sha256 cellar: :any_skip_relocation, sonoma:        "025908e70d860f656c52f6c8eb269290b3b058f772982f57148c62703579b2c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f1c0907b78c5ae29c1ee551c98bdc7430af954f531fad451a74ba7b0a9a05f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68f57c5220158d9d7ce2a5abb713eda80022c38a381aeb57152da7d54e95ec47"
  end

  depends_on "rust" => :build

  def install
    ENV["PREK_COMMIT_HASH"] = ENV["PREK_COMMIT_SHORT_HASH"] = tap.user
    ENV["PREK_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "crates/prek")
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end
