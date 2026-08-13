class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://github.com/golang/vuln/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "70f82d70f3a6757babbeb4e6834536e572d1c822180619ac74b649e3e4f247fb"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f08f4021ab39b533ece496205407f8118deb58adc9d5d46d5c67b838f8ec64c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f08f4021ab39b533ece496205407f8118deb58adc9d5d46d5c67b838f8ec64c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f08f4021ab39b533ece496205407f8118deb58adc9d5d46d5c67b838f8ec64c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cc6d3c13f3893573331d7af9a44bdb60f11304f01f836881fdedfe81601af92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbc633e205e606f9db04158589d782f9d063edb4375f4418c739c1faf9694e9a"
    sha256 cellar: :any,                 x86_64_linux:  "c9a39379bf916135bc3852a7d52458a95266a0562bbb5f30f2c6dc04231f2d31"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args, "./cmd/govulncheck"
  end

  test do
    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"
      (testpath/"brewtest/main.go").write <<~GO
        package main

        func main() {}
      GO

      output = shell_output("#{bin}/govulncheck ./...")
      assert_match "No vulnerabilities found.", output
    end
  end
end
