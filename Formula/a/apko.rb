class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.22.tar.gz"
  sha256 "e77579a3210f5020e140e6cb87e135afa00ef521ac8ab919ac05593c10d2f54f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1162ca371e5580c3f4f486c7d00ddd994c2cbd1883d1eb7d0d0e404cf147ebf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93a1857ecb134e916ed2ddbea26a6a6c2a4827161dc001e63e1987a1e13a23ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "382bdc36a5ae00867cda3fd225972d79eabc8aa5cd4749243de0c59b3a02ff67"
    sha256 cellar: :any_skip_relocation, sonoma:        "57a7a1e053c0bc777d8ccf5a68d65e18b53645d36adf08cce296aee08a682ce4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2206887f069323b2ab1463e079f5dcd8cef17f3b4cad6616ef89a7e703037715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b52df7dee96ffe58bd935e2767834d2be1312a3fe844a2adfa00fcf294eb0e90"
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
