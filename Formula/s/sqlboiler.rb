class Sqlboiler < Formula
  desc "Generate a Go ORM tailored to your database schema"
  homepage "https://github.com/volatiletech/sqlboiler"
  url "https://github.com/volatiletech/sqlboiler/archive/refs/tags/v4.19.7.tar.gz"
  sha256 "b6e3ca096750ef7f917a81045d779126985c5aa68e3179746e05e8d108e9244d"
  license "BSD-3-Clause"
  head "https://github.com/volatiletech/sqlboiler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c25806bc9e49e46a56884c91ce7b0407b17c84b10ef009ba58112773f0ee6c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c25806bc9e49e46a56884c91ce7b0407b17c84b10ef009ba58112773f0ee6c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c25806bc9e49e46a56884c91ce7b0407b17c84b10ef009ba58112773f0ee6c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c876ec35f7993973996f7dae5cbdddb307555bb6428e8dfaf98cb6f1b3fc887"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fde34c3561274c55601a868846947bc7526d017585617f22e590c6d9c1bda31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aafe10042a4d9f3c7ac05bbb8e82bd0e975c7c330d0a35f7e0e04534b2f5fbfc"
  end

  depends_on "go" => :build

  def install
    %w[mssql mysql psql sqlite3].each do |driver|
      f = "sqlboiler-#{driver}"
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/f), "./drivers/#{f}"
    end

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/sqlboiler psql 2>&1", 1)
    assert_match "failed to find key user in config", output

    assert_match version.to_s, shell_output("#{bin}/sqlboiler --version")
  end
end
