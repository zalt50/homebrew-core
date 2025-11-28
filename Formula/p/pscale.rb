class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.263.0.tar.gz"
  sha256 "95b7535bcb97ed7e06b4c0415f06ff99a8ec52cb73f3657215aacc6e5e80d61c"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12012aaa3a7ba893d8bdb396eadabcbb020993924f38c319eb4f99fc3c78be15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0c49d8d710aaab10b7671f92602925f8cf494035b18663ab7341af77f71ba75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccfba80a72d0ae1867e4b6e77688b3eb6455a3da8c6a69f2b145f30ca00aa1e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c02b94ef471b602f5f68bc9500bdde48ffcdd8803f650b561c938d6e6a34c766"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7849479f52d0ece0060868f9900aaf67c0e8d6c61807033abd1c55908eb2da43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baeb65819b03ad72473139bb4ab95622a31ce819a83316bd27f5b697bdcd41f8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
