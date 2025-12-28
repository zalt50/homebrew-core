class Age < Formula
  desc "Simple, modern, secure file encryption"
  homepage "https://github.com/FiloSottile/age"
  url "https://github.com/FiloSottile/age/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "396007bc0bc53de253391493bda1252757ba63af1a19db86cfb60a35cb9d290a"
  license "BSD-3-Clause"
  head "https://github.com/FiloSottile/age.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd07d0e2a72ed2095988733afdd5a948ef9d3ecfc6d2de765bf67660a7b8f7a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd07d0e2a72ed2095988733afdd5a948ef9d3ecfc6d2de765bf67660a7b8f7a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd07d0e2a72ed2095988733afdd5a948ef9d3ecfc6d2de765bf67660a7b8f7a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "baeb714550efa2509d92d8c984295d423dd6d9003dc4505b5e7a290c5b5144b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d92121e0250a95347609107752e2a8e8cf4a5061446f0c58c919ef05e152e112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd3ab3b74840310914044d9c540b9ad753ebda66b664d2d9e874267e79bb2692"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=v#{version}"
    (buildpath/"cmd").each_child(false) do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: bin/cmd), "./cmd/#{cmd}"
    end

    man1.install "doc/age.1"
    man1.install "doc/age-keygen.1"
  end

  test do
    system bin/"age-keygen", "-o", "key.txt"
    pipe_output("#{bin}/age -e -i key.txt -o test.age", "test", 0)
    assert_equal "test", shell_output("#{bin}/age -d -i key.txt test.age")
  end
end
