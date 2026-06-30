class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.8.7.tar.gz"
  sha256 "ed324328d19c710a5c8d03a04e5ee13dd821765205afd75cf5320440f72d9921"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "15c56732e5a8a1be3dd253aa5124d5e0c785e338a7a6114b7bf902a7f08d87de"
    sha256 cellar: :any, arm64_sequoia: "775341fc12c021061acfd2006ed6396cf11c6a841c32dd422d1e474f399f5fa6"
    sha256 cellar: :any, arm64_sonoma:  "59df9c4d122091df382c8a22f6dbb17080ce9dfc49fe438180e59f061aa92858"
    sha256 cellar: :any, sonoma:        "3bdb62b4be3f0aa740287956d30439b5d262d12be22fa3575c9bc6a5759d7ab8"
    sha256 cellar: :any, arm64_linux:   "35c9af00d5e5f251a8a8aa4e10ed6a710ca07cb4dbfee0467d535a9dd6b37cc7"
    sha256 cellar: :any, x86_64_linux:  "8d921f49884ab4ea8f9870d0fdc506e3decfbe76c31e544aea70c3b5c90aea4a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    system "cargo", "install", "--bin", "datadog-static-analyzer",
                               "--bin", "datadog-static-analyzer-git-hook",
                               *std_cargo_args(path: "crates/bins")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/datadog-static-analyzer --version")

    (testpath/"test.py").write "import os\n"
    (testpath/"static-analysis.datadog.yml").write <<~YAML
      rulesets:
        - python-best-practices
    YAML
    output = shell_output("#{bin}/datadog-static-analyzer -i #{testpath} -f sarif " \
                          "-o #{testpath}/output.sarif")
    assert_match "Static Analysis Summary", output
    assert_path_exists testpath/"output.sarif"
  end
end
