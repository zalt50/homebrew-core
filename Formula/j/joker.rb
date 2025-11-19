class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https://joker-lang.org/"
  url "https://github.com/candid82/joker/archive/refs/tags/v1.5.8.tar.gz"
  sha256 "e924fe89d6cde89c8c50937ac898487d70977ef059d5fc6f3a3b57b1fca915b8"
  license "EPL-1.0"
  head "https://github.com/candid82/joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de92cfed1610807a798d13cfbc1291eeb2bb57dde2b6ffb66916e3d5664d6318"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de92cfed1610807a798d13cfbc1291eeb2bb57dde2b6ffb66916e3d5664d6318"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de92cfed1610807a798d13cfbc1291eeb2bb57dde2b6ffb66916e3d5664d6318"
    sha256 cellar: :any_skip_relocation, sonoma:        "8377f78f975c6d434ee5a7cb4c5faee32212c6b0b4c238e60a8a6b49a4b3fffb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3452f141cc899a11d1385b6a059101d60b29bdad0d53753c584818e5ea2bca55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8314e19a8e25ad2370c8dc010c360f45d6273c8936439cc184d04c91858a6cfa"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args
  end

  test do
    test_file = testpath/"test.clj"
    test_file.write <<~CLOJURE
      (ns brewtest)
      (defn -main [& args]
        (let [a 1]))
    CLOJURE

    system bin/"joker", "--format", test_file
    output = shell_output("#{bin}/joker --lint #{test_file} 2>&1", 1)
    assert_match "Parse warning: let form with empty body", output
    assert_match "Parse warning: unused binding: a", output

    assert_match version.to_s, shell_output("#{bin}/joker -v 2>&1")
  end
end
