class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.33.tar.gz"
  sha256 "47c1f7fe924a8e2fa2acf6ea1b7232bc6bfbd6cfe72ef1bc21729ddc68bc95ca"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/apko.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41dc16688ae350fad3c8cea83c520046fe64655acc469bd87880df21022103c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f9c906e6acdf73342273412ea01f044f3efda68c4ffa58aac1981dff66af05d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23f6d043841cdaa8fb896902275e0dab4816ad6eb2cd60332f9b32c2389eb7cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ccd8b82f2df19a623268be99b186e79f95a9438bf3b9583b9aabb3b32850090"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e92b935005f83a94e0a496aff7eb9298bb51159fa87012bb75a574a9322d060"
    sha256 cellar: :any,                 x86_64_linux:  "c6b718301a2dee445e57510feea98bb9ba2ccc16fb7d18af97478ee5176d9d91"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"apko", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"test.yml").write <<~YAML
      contents:
        repositories:
          - https://dl-cdn.alpinelinux.org/alpine/edge/main
        packages:
          - apk-tools

      entrypoint:
        command: /bin/sh -l

      # optional environment configuration
      environment:
        PATH: /usr/sbin:/sbin:/usr/bin:/bin

      # only key found for arch riscv64 [edge],
      archs:
        - riscv64
    YAML
    system bin/"apko", "build", testpath/"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_path_exists testpath/"apko-alpine.tar"

    assert_match version.to_s, shell_output("#{bin}/apko version")
  end
end
