class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v35.0.1.tar.gz"
  sha256 "81a2d2cf72241b69416eaf4f96cfefc60b5c690c0734ef24cb844164c2e7cb9b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3ddaf304813a178ca752ec6ba2dcfae093482a561348f1082220bbf41ec0d35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3ddaf304813a178ca752ec6ba2dcfae093482a561348f1082220bbf41ec0d35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3ddaf304813a178ca752ec6ba2dcfae093482a561348f1082220bbf41ec0d35"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3ddaf304813a178ca752ec6ba2dcfae093482a561348f1082220bbf41ec0d35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77729ae753612918e04617605018d1c3b69a258c353fa214de6dd75c2c30ddec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77729ae753612918e04617605018d1c3b69a258c353fa214de6dd75c2c30ddec"
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
