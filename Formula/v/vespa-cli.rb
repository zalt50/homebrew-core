class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.730.36.tar.gz"
  sha256 "1ac96b8fd69dba61abb8ad130140dbc7ff676b8a1ca95b1b7111e8ce2252a6a1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "696467fc8b83e766190b255447ed8410cce85e335566694c1cacb576c001c22f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89ca23f53a7f11b81666347140f98938e72b05b873615f591aeadb6740728e61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24ae3dff63a448e15d1cb08c60ff5710c4ef23947273b3a79e6f492738f967e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3a29efde7d62e8934b09aaa156d8e256e1fb45ef1cdc0f421587c282fb53c05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ed5104d7245425842dc8a2a28dc5e97597b772048257baf0859b1274129ff77"
    sha256 cellar: :any,                 x86_64_linux:  "cabb29186d6ba4bc0bf7d05c6b4b79b37a6cc6b3f808c13f5a925dedbb8ae41b"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", shell_parameter_format: :cobra)
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
