class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "d45e0291e9eddf0f72aab33fc6190371d8c4bf421285ff07222a7dd6c4da8518"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d66cf839bb774b87536378a0f48a14b94432d9ebed3606b97057449c89ae8bbd"
    sha256 cellar: :any, arm64_sequoia: "7378f9d47952f4734d186038b9c413940e33e53da2f33abb9d369215d8255811"
    sha256 cellar: :any, arm64_sonoma:  "9fbd1a1e83a519357cf5cba698495a6f70b781954439ebb668bcda1e2d41b3d6"
    sha256 cellar: :any, sonoma:        "2c3bfc71af92282991787c59f81b3ae58303fefba36068ccdfd2fb7cd8cc559f"
    sha256 cellar: :any, arm64_linux:   "c2cfa2ed21b1b84a43c4af9da62afdd6dd40902893ddeb75a6e57c2372e542ed"
    sha256 cellar: :any, x86_64_linux:  "0a7be46b4678ac36e9db8d8b824cb68c92cb363375e9821aa96fd4b466a45c4e"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (etc/"dolt").mkpath
    touch etc/"dolt/config.yaml"
  end

  service do
    run [opt_bin/"dolt", "sql-server", "--config", etc/"dolt/config.yaml"]
    keep_alive true
    log_path var/"log/dolt.log"
    error_log_path var/"log/dolt.error.log"
    working_dir var/"dolt"
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
