class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v31.3.0.tar.gz"
  sha256 "d17a85cf938bd0ec8f21fbb56a9d6f33367d19872a0eb32dac923d6090a240c9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af6e3f26205802d7512eb1cf294fd0bc66bb3e65387ddf18a8ca8ea7c900e897"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af6e3f26205802d7512eb1cf294fd0bc66bb3e65387ddf18a8ca8ea7c900e897"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af6e3f26205802d7512eb1cf294fd0bc66bb3e65387ddf18a8ca8ea7c900e897"
    sha256 cellar: :any_skip_relocation, sonoma:        "af6e3f26205802d7512eb1cf294fd0bc66bb3e65387ddf18a8ca8ea7c900e897"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0688fdab8a50053912659bfa4ffaa4e7ae2e9553565edced8975efdbb12180cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0688fdab8a50053912659bfa4ffaa4e7ae2e9553565edced8975efdbb12180cf"
  end

  depends_on "bazel" => [:build, :test]
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk")
    rm ".bazelversion"

    extra_bazel_args = %w[
      -c opt
      --@protobuf//bazel/toolchains:prefer_prebuilt_protoc
      --enable_bzlmod
      --java_runtime_version=local_jdk
      --tool_java_runtime_version=local_jdk
      --repo_contents_cache=
    ]

    system "bazel", "build", *extra_bazel_args, "//cli:bazel-diff_deploy.jar"

    libexec.install "bazel-bin/cli/bazel-diff_deploy.jar"
    bin.write_jar_script libexec/"bazel-diff_deploy.jar", "bazel-diff"
  end

  test do
    output = shell_output("#{bin}/bazel-diff generate-hashes --workspacePath=#{testpath} 2>&1", 1)
    assert_match "ERROR: The 'info' command is only supported from within a workspace", output
  end
end
