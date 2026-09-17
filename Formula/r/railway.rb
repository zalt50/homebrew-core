class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.57.8.tar.gz"
  sha256 "b9ef59be8cf13b50958d7bccbffbc5d6ad1827ced2cac2082cce814b0018e2b2"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "28486ba02873319f522c4649e3b103e425014eff25ebfa941e407258fa004654"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9419bb6672022731fab5b0dcc7c79d645af2aee548cbf046532304f0e72662e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9542ffff51802d9db7bee7661b17c06e281198fc30d716f364dd25830062fb45"
    sha256 cellar: :any,                 arm64_linux:       "02622f2d5ffb81c9e9bdc8b33105170f00a1f37983e8e831fbaef439486d3c0b"
    sha256 cellar: :any,                 x86_64_linux:      "0ed7b9f30c321d868a9b03bd7e12ab16d13877cfab4800bdab3259ff1603e2dc"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

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
