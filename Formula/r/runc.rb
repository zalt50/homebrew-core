class Runc < Formula
  desc "CLI tool for spawning and running containers according to the OCI specification"
  homepage "https://github.com/opencontainers/runc"
  url "https://github.com/opencontainers/runc/releases/download/v1.4.3/runc.tar.xz"
  sha256 "13b8b214419e26466a2e0802a098f0759ef2b942880ec242786338b3b7534445"
  license "Apache-2.0"
  head "https://github.com/opencontainers/runc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "19363a75c36317ef5dafbfb85310994d7e182daccf5b02248c6e9cdbf3aa377c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4e949d68f7b462085b7e76c3079e982f5b0e5591fa4f902cc3eed960d7d13200"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "pkgconf" => :build
  depends_on "libseccomp"
  depends_on :linux

  def install
    ENV.O0 # https://github.com/Homebrew/brew/issues/14763
    system "make"
    system "make", "install", "install-man", "PREFIX=#{prefix}"
    bash_completion.install "contrib/completions/bash/runc"
  end

  test do
    system sbin/"runc", "spec", "--bundle", testpath
    assert_path_exists testpath/"config.json"
  end
end
