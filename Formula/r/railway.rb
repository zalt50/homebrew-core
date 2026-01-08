class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.18.2.tar.gz"
  sha256 "7eaab65be401d4e9904d5c5262a2b6ede1a1338a5f17aa2a88534cf6e963b729"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a76c3817e08833238133ec170b2d56063d65b48d80bf3bd1f1b4433a061259be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed39680f0332750f9a8b09f10af8acd9a53d8bef7f78fb326aa3880f290ce4bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5314c599da02d458de03a668c911c3dc115219bc83f5cbb2f5b72d04674c5116"
    sha256 cellar: :any_skip_relocation, sonoma:        "524690f2443037776ac77287ced09c8a64fe571c74434dd921523e23fe08c1ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "096864a03ce7f396e488507b0f4a4a2e5f4cbe68f89389a83f902bfdc9200d26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb896003f69fb58597ff8e44159394213586770e241a5d43e0831608483a6324"
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
