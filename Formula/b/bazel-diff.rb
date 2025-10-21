class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/11.0.2/bazel-diff_deploy.jar"
  sha256 "741537e96616174e4a559bbb80cc98325ed2f292562750de477d7cceacd34c49"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b94f0e97c498a4c087069ff33d17570a0e4b983525ac91d872afa87d6a8fe840"
  end

  depends_on "bazel" => :test
  depends_on "openjdk"

  def install
    libexec.install "bazel-diff_deploy.jar"
    bin.write_jar_script libexec/"bazel-diff_deploy.jar", "bazel-diff"
  end

  test do
    output = shell_output("#{bin}/bazel-diff generate-hashes --workspacePath=#{testpath} 2>&1", 1)
    assert_match "ERROR: The 'info' command is only supported from within a workspace", output
  end
end
