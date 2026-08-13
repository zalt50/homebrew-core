class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.39.0.tar.gz"
  sha256 "bd01e68b24b00e55ebe8b5eefef2a0e5d7f3198a9eeb8c254190920c065a0e69"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7faa6e3a88acbd4c0eb4388150ad98621ff3d0ddab15cf10f6687e4e521d1f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8e54da6fc51d810966f57bca827d6ad238d2814d2f8d05e79a4602df830af71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c51e9ab1e9546f97f81726ac5406728c13aa88909ad44059df6ed8d9a63b48e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9c4764b2f925840718383db71eec0df5196eefe4247d23dd6354e0a36e3d407"
    sha256 cellar: :any,                 arm64_linux:   "eb232e6216370f865f5f9c1b5c971790636c641b0c261754a6e2bdf6416aca9a"
    sha256 cellar: :any,                 x86_64_linux:  "5cb48579f07479a9c5d5f5327561866c2887be1055ae096bca50880909341331"
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
