class Openlist < Formula
  desc "New AList fork addressing anti-trust issues"
  homepage "https://doc.oplist.org/"
  url "https://github.com/OpenListTeam/OpenList/archive/refs/tags/v4.2.2.tar.gz"
  sha256 "4f630caffb625bfd8a8c6bd9f798f7b36bd6147932a450c0b9f6e3ac2979fdbe"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "668cbc4267646fc411fd647540d103daf1076d1679e7c16df71ea32b6220cc29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9513b136bd1890948acf4154953a01dbe364e9c799e7c46e6499934f7a084d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "323094edd9f99f355ae931100b8409d91bef356df69f43b5845d522c96915845"
    sha256 cellar: :any_skip_relocation, sonoma:        "c15005d4df2e1ed487de513955633abf5c8cd297cd23178cf909c5e50734014c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ee6d23ece71f8f06408adfdf9a2b50078feb071135b22b82c41670c81172a93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c484df8de5ce1e1d69b304283d25a2159bcdebc014cccb9127a3e61d81a29c8"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  on_linux do
    depends_on "sqlite" => :build
  end

  resource "frontend" do
    url "https://github.com/OpenListTeam/OpenList-Frontend/archive/refs/tags/v4.2.2.tar.gz"
    sha256 "361354a219d4c31e42933fd6423d56e740184ae0b709440a1df1f368f13474fb"

    livecheck do
      formula :parent
    end
  end

  resource "i18n" do
    url "https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v4.2.2/i18n.tar.gz"
    sha256 "519bf24349c9bac9078840a9b744fcf744492cf2b4ef0ae6445fc6eab888f79a"

    livecheck do
      formula :parent
    end
  end

  def install
    resource("i18n").stage buildpath/"i18n"

    resource("frontend").stage do
      cp_r buildpath/"i18n", Pathname.pwd/"src/lang"

      system "pnpm", "install"
      system "pnpm", "build"
      cp_r Pathname.pwd/"dist", buildpath/"public"
    end

    ldflags = %W[
      -s -w
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.BuiltAt=#{time.iso8601}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.GoVersion=#{Formula["go"].version}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.GitAuthor=#{tap.user}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.GitCommit=#{tap.user}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.Version=#{version}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.WebVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/openlist help")
    assert_match(/Version: #{version}/, shell_output("#{bin}/openlist version"))

    test_data_dir = testpath/"data"
    pid = Process.spawn(bin/"openlist", "server", "--data", test_data_dir)

    max_attempts = 10
    attempt = 0
    http_status = "000"

    while attempt < max_attempts
      sleep 3
      http_status = shell_output("curl -s -o /dev/null -w '%<http_code>s' http://127.0.0.1:5244/ 2>&1").strip

      break if http_status != "000" && http_status != "000s"

      attempt += 1
    end

    if pid
      Process.kill("TERM", pid)
      Process.wait(pid)
    end

    refute_equal "000", http_status
  end
end
