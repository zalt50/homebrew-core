class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.33.tar.gz"
  sha256 "28a2f9bfac8cc1558ca942bb2ffe0a6b22f25568a5bb161f352be25a2572e453"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d10bb86ad75fd83ae27cafa2335428ce8995e73df57d5f1244d3e013960cd8c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "828631c3d24958596a1bcd4f6e0626f5e6c9d9826d46bc33039d0ca1e3b13075"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46fdb21c9e4f4180dc0d16e008fb5cb361f060f469a4c5d037da6a45b1d82a03"
    sha256 cellar: :any_skip_relocation, sonoma:        "099dd2ea43d11ed3fd810a3c5064f5d31d908989575a32d62ec5d4c6d60d4e95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "849f1e8ce937161c981c2495cfabfb04c945670b6e89a8e687168f896d50dcf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7127956bca9f3ea11635537309b603841866321cbaeb52c053f4c5c93965556"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"apko", "completion")
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
