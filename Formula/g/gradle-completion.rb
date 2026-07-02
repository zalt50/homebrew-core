class GradleCompletion < Formula
  desc "Bash and Zsh completion for Gradle"
  homepage "https://gradle.org/"
  url "https://github.com/gradle/gradle-completion/archive/refs/tags/v9.6.1.tar.gz"
  sha256 "f6692560abd24b0fe85f57b4b12f9382924ac960c70f85956bbb1e6bd19fb13f"
  license "MIT"
  compatibility_version 1
  head "https://github.com/gradle/gradle-completion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "396b01159d221b4b92518a142a17a293703bf9d371f8ce11ef0d378b3b157a65"
  end

  def install
    bash_completion.install "gradle-completion.bash" => "gradle"
    zsh_completion.install "_gradle" => "_gradle"
  end

  test do
    assert_match "-F _gradle",
      shell_output("bash -c 'source #{bash_completion}/gradle && complete -p gradle'")
  end
end
