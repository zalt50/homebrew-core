class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "0819ae6195d49930548c9a3bdf16ddb0ce35de333eaa69715127981973dfdd98"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df6287f6323a3e40e98a19d19316c4e547af0d31553ba1140214b59d049926fb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "08450240d31106ce7decf788e8b052c7682b7efa75520483aef2ff04e221ea89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "601ac5907dfca04d6aba1ceca566a69327d35c65312f732469a9839defe61b50"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ddc277bbc48f00d886e3c39811710cd4430bc8124bb50c502f6d9e7bba5ec780"
    sha256 cellar: :any,                 x86_64_linux:      "9eadc77b09e871fb74762d3ce37049bb9ecf77550fe866a42f53e07b33cc894f"
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
