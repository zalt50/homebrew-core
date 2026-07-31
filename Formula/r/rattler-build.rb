class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.72.1.tar.gz"
  sha256 "69285be0501e2a4fb9aa733914083a682c2f8ad65d793d23ee59e0b553bf52e5"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/rattler-build.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "967f09f025f6f7955661fb841bf782a05855d46116989c53e78e037a1d5dcf13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0203d060b10699d711404747507577cea9faa94365a968a34dfd173093295599"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfa1d520a45179b9569a6e42ea4f6150cd6af7aba40241dd3d73620d518d0dda"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecda7db888f25de8266759f3f9ccafa593f3031fdccee1dee07ac7fbf1acaa69"
    sha256 cellar: :any,                 arm64_linux:   "e78f770b72fef26dcbcafa6d3a7f9b8f3860ca700ec2530ca27e9dd95b60d33f"
    sha256 cellar: :any,                 x86_64_linux:  "c417e84faa2bed0dbac4babb4255ad47f22614b65003d2a5fd2911baa3528829"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rattler-build", "completion", "--shell")
  end

  test do
    (testpath/"recipe/recipe.yaml").write <<~YAML
      package:
        name: test-package
        version: '0.1.0'

      build:
        noarch: generic
        string: buildstring
        script:
          - mkdir -p "$PREFIX/bin"
          - echo "echo Hello World!" >> "$PREFIX/bin/hello"
          - chmod +x "$PREFIX/bin/hello"

      requirements:
        run:
          - python

      tests:
        - script:
          - test -f "$PREFIX/bin/hello"
          - hello | grep "Hello World!"
    YAML
    system bin/"rattler-build", "build", "--recipe", "recipe/recipe.yaml"
    assert_path_exists testpath/"output/noarch/test-package-0.1.0-buildstring.conda"

    assert_match version.to_s, shell_output("#{bin}/rattler-build --version")
  end
end
