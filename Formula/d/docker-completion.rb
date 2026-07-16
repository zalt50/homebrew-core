class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli/archive/refs/tags/v29.6.2.tar.gz"
  sha256 "11aef3484c38d39d291a54a73a4d9dd2bb3c000d9a3fc3862bd03fe899594f2c"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ca89b3fa67bc48342b266d6a2595db1d32cde07cde63547ee1c2fd3c0d89d236"
  end

  deprecate! date: "2026-05-31", because: :deprecated_upstream, replacement_formula: "docker"
  disable! date: "2027-05-31", because: :deprecated_upstream, replacement_formula: "docker"

  conflicts_with cask: "docker-desktop"

  # These used to also be provided by the `docker` formula.
  link_overwrite "etc/bash_completion.d/docker"
  link_overwrite "share/fish/vendor_completions.d/docker.fish"
  link_overwrite "share/zsh/site-functions/_docker"

  def install
    bash_completion.install "contrib/completion/bash/docker"
    fish_completion.install "contrib/completion/fish/docker.fish"
    zsh_completion.install "contrib/completion/zsh/_docker"
  end

  test do
    assert_match "-F _docker",
      shell_output("bash -c 'source #{bash_completion}/docker && complete -p docker'")
  end
end
