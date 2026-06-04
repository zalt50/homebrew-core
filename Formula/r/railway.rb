class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.66.2.tar.gz"
  sha256 "bfa1895092e7747b1b3492677020e26f1aaa6b2154cffc7f8824d6096b498a59"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b37a271cf6280c9adbc6d45a0483bbd03447ff8662306cc1d3e4d26961fd2a6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64582131ea3c1d30f42ad7b768a15b191663cb7ec4d0c98149ea71f24cc076e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "090b2954ae9036fc2c6d9def3f442eb2c1111813708d29e2a2fb28ec540f6adf"
    sha256 cellar: :any_skip_relocation, sonoma:        "96c7c8a1206bbbfea5ed996294cee44228eb235800992fab042b87a0613bc233"
    sha256 cellar: :any,                 arm64_linux:   "b382d67c6e53542c36876fb885cd141a66b605a25d120151ebf159766d5885d1"
    sha256 cellar: :any,                 x86_64_linux:  "e00273e1622f7a6cde3c8533095039cdb3a89b1c749e016c4e7d634057d74465"
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
