class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.2.16.tar.gz"
  sha256 "64e9f0bbe12e7e944dfd0e55f1d1ae35dcc95ed35929e8130f604edee0776c80"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b65de7fb3d2ace7dc260cc97be7079d2d851f9ffb8aff3a6731f22e85757ddd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b614a68890e2b765e9576ba7ca6140f624631c7de94101667944baef5e2a115"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d69ee480ebf4079d90b1e115864d2a2eefa07dda678eb8f5c1cd5874c5d7d26e"
    sha256 cellar: :any_skip_relocation, sonoma:        "59bf54ee5d7ffc8fa5dbdcc0d97390c892c509f4a14fb80fc8820d484f91f2bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1ca4dce2fc1808daecef13bb27980f9123bb7c8ec3750eae567faf5ab220dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1d419996200fdb8e5b8148ff61afca6779cf6a9659d88d20ec8a5852ca05350"
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
