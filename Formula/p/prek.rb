class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.2.16.tar.gz"
  sha256 "64e9f0bbe12e7e944dfd0e55f1d1ae35dcc95ed35929e8130f604edee0776c80"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d034900cc159d91b2d767c5387a8b7ed527905062fe4fa64268fa696a7541e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4233b505dc9367a1fb2dc402981183a4548bd3ef44e25c00731fbfd719945f1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb6950da24e9016af6d03fb4a674f8b78f96cdf6bad5cdc192c27c77855647ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "e22a39beb79c4ebb6dd16e7a55e1c1b8caba363136ca55566d31e6c26d709db3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27b9dc1aee4086fcbdebf5c1369d947c63a664c0108d9b0def77c1cb1446aab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed498e27bf88d222ef9888f59da979dcfca04ec4f7d77d35a779e50378dbf770"
  end

  depends_on "rust" => :build

  def install
    ENV["PREK_COMMIT_HASH"] = ENV["PREK_COMMIT_SHORT_HASH"] = tap.user
    ENV["PREK_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end
