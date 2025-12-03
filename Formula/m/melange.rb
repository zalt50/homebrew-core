class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.34.2.tar.gz"
  sha256 "5763347593c87e626f3e455c2accd97f97c2c517b6064e0e7004a0b1877fea2a"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0438308995910c8c6e6c78c7e53392bf63f4ca4fb6ecea8d1742f84f7e534a9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac8b9a2df60ee8cf7fe919408ce8e6edf015e7818c09bf47e9ee3b99f87d36fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9d2017422d8de7282f5669e8fe6bb8aaebc81f7cf2a52ec24e93b006fe35121"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fa714a9326e11578b0c8bcd9325faadf1c8060b75c2364688deb01626f35217"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad1493e95615e0d31ab86ec471bf7f24601a0da700e8c81fb0c45ecce46f4774"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3da97f526fe28af4bee3208bbeee76b06ce82fb31e21ea86d44f76cd5b7413e4"
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

    generate_completions_from_executable(bin/"melange", "completion")
  end

  test do
    (testpath/"test.yml").write <<~YAML
      package:
        name: hello
        version: 2.12
        epoch: 0
        description: "the GNU hello world program"
        copyright:
          - paths:
            - "*"
            attestation: |
              Copyright 1992, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2005,
              2006, 2007, 2008, 2010, 2011, 2013, 2014, 2022 Free Software Foundation,
              Inc.
            license: GPL-3.0-or-later
        dependencies:
          runtime:

      environment:
        contents:
          repositories:
            - https://dl-cdn.alpinelinux.org/alpine/edge/main
          packages:
            - alpine-baselayout-data
            - busybox
            - build-base
            - scanelf
            - ssl_client
            - ca-certificates-bundle

      pipeline:
        - uses: fetch
          with:
            uri: https://ftp.gnu.org/gnu/hello/hello-${{package.version}}.tar.gz
            expected-sha256: cf04af86dc085268c5f4470fbae49b18afbc221b78096aab842d934a76bad0ab
        - uses: autoconf/configure
        - uses: autoconf/make
        - uses: autoconf/make-install
        - uses: strip
    YAML

    assert_equal "hello-2.12-r0", shell_output("#{bin}/melange package-version #{testpath}/test.yml")

    system bin/"melange", "keygen"
    assert_path_exists testpath/"melange.rsa"

    assert_match version.to_s, shell_output("#{bin}/melange version 2>&1")
  end
end
