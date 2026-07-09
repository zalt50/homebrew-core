class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.26.0.tar.gz"
  sha256 "ea5ea09ed149fa5e7f84646045b7d9b17d91aa84d4e7a995dd3716099869323d"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f12b44bc605f3bb858d1a81ae82d0250d34437f4cbfa1bbafa30c98365dc215"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0da461e9f1ea611933a8631cf4a0ac4f8e7e996ea1b463743edf05b2c20d060"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad1cb9f57f8928ede6542feb6337bf62bf945032fbf6d810df2b49dc2be3807e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c14f44507b5a4ba20f02f97e87eccf2414b59dd752d710926ca1a137c0bfaac0"
    sha256 cellar: :any,                 arm64_linux:   "f74b415f95e103c16dd193074f4d0344e1bd2b59666231f0ac2bbc46ba814906"
    sha256 cellar: :any,                 x86_64_linux:  "55634accc8fdfe83d7f8fa72cf9641f11e5a7bfd8341751c154421e8150c4de6"
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
