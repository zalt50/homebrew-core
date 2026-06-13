class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https://changie.dev/"
  url "https://github.com/miniscruff/changie/archive/refs/tags/v1.24.2.tar.gz"
  sha256 "57eab8209ed18e938ddb033fb6e3bd62229d442da728f7e75027d4117716ba57"
  license "MIT"
  head "https://github.com/miniscruff/changie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b8c7a772d22945664c819188760f965a5eb980dcf9e1b70cbf2cd613ea8d5ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b8c7a772d22945664c819188760f965a5eb980dcf9e1b70cbf2cd613ea8d5ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b8c7a772d22945664c819188760f965a5eb980dcf9e1b70cbf2cd613ea8d5ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d1cb0bc66debb06f873a96910a84face35d8da178ced5b8d4ea5b68daf679cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c96035292ae6111bfab9a5c4ecf9aa684ae3540347a3a059fd2e2df75f9a20ed"
    sha256 cellar: :any,                 x86_64_linux:  "cd187fb73f02ff1f7dd2ff6f05715e2dda837927375fb6e9fe787e349f8d55ca"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"changie", shell_parameter_format: :cobra)
  end

  test do
    system bin/"changie", "init"
    assert_match "All notable changes to this project", (testpath/"CHANGELOG.md").read

    assert_match version.to_s, shell_output("#{bin}/changie --version")
  end
end
