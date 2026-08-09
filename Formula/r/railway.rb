class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.34.4.tar.gz"
  sha256 "b9429d513b9ee3da5d1d66440ce71affc348ca9fd43853a8182f3b8324b85e90"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2609cdb17f559746fb400c2a8f7d2fef49b9185ec8b600d9223079f54748314b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72f39878e4e8ac485471a7af66f897575601364bc84ab434631135576c10bb8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "943a2b8d2ea8fc37b51754a8ba1e1d800f91187467ae631f4256b8571209d01c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d666f08f0a8453b6d179dc902bd0611cbc4c19f139b5cc48131ec6b3302189e0"
    sha256 cellar: :any,                 arm64_linux:   "64f1bad3b26bb56e84d8587accf6533e17c7b5717d7ae8e9e60175bea942052f"
    sha256 cellar: :any,                 x86_64_linux:  "e4607919121208ca54214608b28b28669cf718b60dfd2d2f29c619d40c246e01"
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
