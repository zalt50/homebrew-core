class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://github.com/DopplerHQ/cli/archive/refs/tags/3.76.2.tar.gz"
  sha256 "6327afe38b0d42e09d0acd5ea9a4dbc66e1ce6666b6907bf6eb0efc4e5ae0189"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e080226a376813274d40b40892507d6fbe10e57646e65ca2e1c60485537ffa7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e080226a376813274d40b40892507d6fbe10e57646e65ca2e1c60485537ffa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e080226a376813274d40b40892507d6fbe10e57646e65ca2e1c60485537ffa7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0365019f5aba3f8bddf51b6a733584f31658d87e6d25b2d62f95112c42fbed9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bdbee30f172180d6889e304f8d7d0198dcfd3e2d10d340f39187e83e8a7685e"
    sha256 cellar: :any,                 x86_64_linux:  "cf26980666f59d22bc246d05fed35535a44442b59736e241c4980918326ea660"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=dev-#{version}]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"doppler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doppler --version")

    output = shell_output("#{bin}/doppler setup 2>&1", 1)
    assert_match "Doppler Error: you must provide a token", output
  end
end
