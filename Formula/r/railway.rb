class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.23.2.tar.gz"
  sha256 "6155cd2577fe2be525c2c109d439e4c6d57ffbcd4d0eefee027bc5d1929aec3e"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0a7b6a435aa8ebe440d15ba78ef4abba8eb48d161a1936a4283b618c30b5407"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "240134887c73a8abfd96a05c0d3eff5ddc8cd2474f0d4032114ec82bd330984f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d28c98cdfc072bc364ac259ebb76500a21eee310efc63bd64163c6d4f0d7f6b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0389c85ac2be0133712d99e4719ae9d1814ecdffe4a3ea1aeccaf54319211f73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c981f055e8a2e98990e3272e2ca44839318bc98d50507bdf10502a8a28665d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0c7e274e8ea463f9d981f713f8ce08e5675d20c791d4a5368c60b528da1f26b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
