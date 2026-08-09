class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.35.0.tar.gz"
  sha256 "beef9d2a475e53474c8de4864df79a2f38ac360dae37cb27feca68c076247eaf"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4567141e8d8b0d2043a90f88b76d46d3fcb0cd24d288b913824e309a5e26785e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19b928e8a3d52113b75812a63245a95f57d664da643ce3a9bb3efb6ce9230950"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ebd555a5378b97f4d4ca441cfcd10edb167e7d2004613ebebd56ad4ab07fe38"
    sha256 cellar: :any_skip_relocation, sonoma:        "293974687489843b6c8d8ba4804912115e6ccb6f53cdd639bf2346acbda27d7e"
    sha256 cellar: :any,                 arm64_linux:   "ec4010a9316f574796fc396451615d2c3609918bdbf2d2d609bd84dff878064a"
    sha256 cellar: :any,                 x86_64_linux:  "d287a5af08f8c516fceea6c68c052b1e50a6df1a4a5099cd29371b321ab96548"
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
