class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://github.com/unikraft/kraftkit/archive/refs/tags/v0.12.12.tar.gz"
  sha256 "46116aefde52c633d6ad5e6f90832b9545c245dc826f9efb8a36b02908450ad7"
  license "BSD-3-Clause"
  head "https://github.com/unikraft/kraftkit.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be0a85fbb4c896a2ea94541246cce23b8667d4d464856d6dece973d007068762"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17b57ff8c59b13d06e9c542db7e290f9e7c2c2a8c0d80acd2f3102f07c2423d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8b95c89507c6dd645615e205560645e19075e6a27d345a7348ee37a84af4144"
    sha256 cellar: :any_skip_relocation, sonoma:        "a96a9c7dcda5a4f695dacd559cf3a532a6f2189287b62b9a2cf032ec666b43b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43b2ee7cad6c2a51b87f222f7a54294a75e671ab2e0337dc17c9390885581319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a47414711f0a8a5b46d151d3e05535259bad6f7f6aa48d5fd23cdd7873abd199"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -s -w
      -X kraftkit.sh/internal/version.version=#{version}
      -X kraftkit.sh/internal/version.commit=#{tap.user}
      -X kraftkit.sh/internal/version.buildTime=#{time.iso8601}
    ]
    # Upstream suggested workaround for undefined: securejoin functions
    # Issue ref: https://github.com/unikraft/kraftkit/issues/2581
    tags = %w[
      containers_image_storage_stub containers_image_openpgp netgo osusergo
    ]
    system "go", "build", *std_go_args(ldflags:, tags:, output: bin/"kraft"), "./cmd/kraft"

    generate_completions_from_executable(bin/"kraft", shell_parameter_format: :cobra)
  end

  test do
    expected = "finding 1 unikraft.org/helloworld:latest"
    assert_match expected, shell_output("#{bin}/kraft run unikraft.org/helloworld:latest 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/kraft version")
  end
end
