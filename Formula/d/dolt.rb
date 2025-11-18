class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.78.0.tar.gz"
  sha256 "615bd81d21699035ad419d6b2a5a042f09953f644fc82c0f64eae37edc7b0b32"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7090200631313db088488d3fcfdbc384f62b056ae586b08f6e226d5bd0bf46b5"
    sha256 cellar: :any,                 arm64_sequoia: "29db1e5f61048b1f0b5d2ed5346a3479c0720ebf2636b220d04451daa7238c2d"
    sha256 cellar: :any,                 arm64_sonoma:  "721f3e3c203813dc8ec77b6fa3cb8a9aab185386f9924dc11a570f648d8debc5"
    sha256 cellar: :any,                 sonoma:        "8ddb47a249e9041cbaf4118d45347f37ce2e9e75647dc184cf31ce800e869255"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d313188cd5682673f9e52e9d0375bd1aac1d9ba9d8cce8c02296a3652209ab08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58b34aaa7a92a5b8c58f689ed27f6179e2ff8cd0c32a201ef6f4740fed337fd1"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
    end
  end

  def post_install
    (var/"log").mkpath unless (var/"log").exist?
    (var/"dolt").mkpath
  end

  service do
    run [opt_bin/"dolt", "sql-server"]
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
