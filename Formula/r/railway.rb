class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.37.2.tar.gz"
  sha256 "c9dd3d9f363bb273e218adf4ba98b8874358e6880a05d3a6a1f860df2cb0281a"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05f852df768c9cc7bc4a276e27cd85ef50dc8a44597409aa5612bb5d6c6457ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1788aed82716d0c1cff0db96ded6203ea8c34400350b072d0aa38b8a51c8fb9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d42861b039627cd580a5816a92446885218a452e5c1c02abd05ac0c0cd3a045"
    sha256 cellar: :any_skip_relocation, sonoma:        "307734a2dbf721c1d61fd9b30897f1f4d620f1c6b632e1dffcc3473cfa8e8f08"
    sha256 cellar: :any,                 arm64_linux:   "ba9f7e126e5f7bd6d758b214052a6d09a3d4d9933348603f9671f9895f9355a4"
    sha256 cellar: :any,                 x86_64_linux:  "ebeea9e61defee7778f962cbeb63b8307fc18bb95415f855a5b291b529369b0b"
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
