class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.57.6.tar.gz"
  sha256 "5d5644ca6722607aac5f2b527200673b4f383c6b2c98ec778cad8a4aa8ce23b8"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "254cd4c5b44d30a678098ba8b62c6d2a5103060e1769d7e58f6320ba1eef9bc8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "89da1eece1daed02bc972a4298a1d0f834854933add54380b857b98c176c1a08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4edd4f5bd2b036a894a7c9f77950ddada560913b7e9be374d6e78d78173d8282"
    sha256 cellar: :any,                 arm64_linux:       "6ddc98728fb51c7dbeaa46175122d1b24eb89993692e99bef8c9c8f30a6bac04"
    sha256 cellar: :any,                 x86_64_linux:      "6cb7aaefdc406b9b6749f957c4a8e0287c78287c70ecb3be5027f5062399ee88"
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
