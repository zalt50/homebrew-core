class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.26.3/gitea-src-1.26.3.tar.gz"
  sha256 "20b8ce7858ca17464d976ed4d3e94e2c50ad5a571de7a4e7cd66e54d6ed4eeec"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9962dfdbd7421f68c6fceb2afe6385f0382d3650c6fd6649a61340f14d219ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6c8951b5526b9539198105438d7e97cee00c4ebc52d47b767d20e2ca678fa50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04471e44fbfa88b19c14c59a7febe6fb7d11cb7b6e5b1220febbe5a2d825c1d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e926347a379c44c204931be1a6d39c5b43a7ea60928235d5ed59461994fac959"
    sha256 cellar: :any,                 arm64_linux:   "914bfa05b8be27da53c16022ed119261d7fc80619162bd418d4a64136167aec9"
    sha256 cellar: :any,                 x86_64_linux:  "281eb0ca309c9a40f6569188d665a0217d874db4f3265988a9e3f3ff7854a4ec"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  uses_from_macos "sqlite"

  def install
    ENV["TAGS"] = "bindata sqlite sqlite_unlock_notify"
    system "make", "build"
    bin.install "gitea"
    system bin/"gitea", "docs", "--man", "-o", "gitea.1"
    man1.install "gitea.1"
    generate_completions_from_executable(bin/"gitea", shell_parameter_format: :cobra, shells: [:bash, :fish, :zsh])
  end

  service do
    run [opt_bin/"gitea", "web", "--work-path", var/"gitea"]
    keep_alive true
    log_path var/"log/gitea.log"
    error_log_path var/"log/gitea.log"
  end

  test do
    ENV["GITEA_WORK_DIR"] = testpath
    port = free_port

    pid = spawn bin/"gitea", "web", "--port", port.to_s, "--install-port", port.to_s

    output = shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}/api/settings/api")
    assert_match "Go to default page", output

    output = shell_output("curl -s http://localhost:#{port}/")
    assert_match "Installation - Gitea: Git with a cup of tea", output

    assert_match version.to_s, shell_output("#{bin}/gitea -v")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
