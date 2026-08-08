class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.33.0.tar.gz"
  sha256 "32267e240eb80c0cd98e236b8916b7e525846c76893080dc8d8ecdff624cdffb"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fb602dafdce0b21c62483bbcad6c630f17f0d943ede4458cfea18efcb43edbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "000ac0f0429e069974339aa7c3d19b28237e4ddfd25bb4f9f20bfbd6142611bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc7f5ad39c6861a45a22920d97dc41aa90f2cd09d6636ff909a858cd84285b6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "091b8787937c6b6236aa01d9ff8bd4fd36292035223a97c2e7ed679bb3df9fe6"
    sha256 cellar: :any,                 arm64_linux:   "797742eed8dcee01a6c806dc47c88ec6991b4027e9745e84a40ceda8e52cc80d"
    sha256 cellar: :any,                 x86_64_linux:  "287d0012d70134c528e2c11850f3845842ddc7759ced7380db3828198f523f8e"
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
