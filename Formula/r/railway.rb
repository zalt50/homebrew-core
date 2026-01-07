class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.17.1.tar.gz"
  sha256 "68681ee61dd3b4ed0e76ef4395e5ba3f8b65f244a993f0a53c0ff7f85cd419e1"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64d7b46cf995a4bb29bf42dbe0c96b1b6fa3b2077aa574819d83f6e48684356b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0293eb745d72d5b27975fd1ccf8dc34fea4b4131c6c24c35858eb72caca78bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09a61cddb4cdcde04f7848e889e496347236a451c02cac873a9cfd63f10e0888"
    sha256 cellar: :any_skip_relocation, sonoma:        "157262b98122049437f068218539455f9e97a130064155b26bf457f1ad5773af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6b45a949646944453bdd4dc490575cc2de214b58bc777539ad759b991fc9eb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea1f93d61499ce1dc123acb9ef0e2a82945b1dd06c98122da91bc0e4e33b6e19"
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
