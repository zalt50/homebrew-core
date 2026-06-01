class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "d849add0992259baddeb1ff5821c465ff6f2f4626e03d57d7a9ec788e6df93f5"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f744215f40ce6215d5d4d47da7098b7e275e5587959f7b9e7abf93da0589b102"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f744215f40ce6215d5d4d47da7098b7e275e5587959f7b9e7abf93da0589b102"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f744215f40ce6215d5d4d47da7098b7e275e5587959f7b9e7abf93da0589b102"
    sha256 cellar: :any_skip_relocation, sonoma:        "5edbef66cb4093e6d25a1409ed2de7539eeac903a9f01b184e0ecf11676165e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6159899734fd90af182cb6670a8586e16077c1f18aa59b4c05fd36eab4aec68"
    sha256 cellar: :any,                 x86_64_linux:  "050a687ccd7deb798dbfd4d42e367f4a56d33115be01040f5da7de4f9b8aa40f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end
