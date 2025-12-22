class Hayagriva < Formula
  desc "Bibliography management tool"
  homepage "https://github.com/typst/hayagriva"
  url "https://github.com/typst/hayagriva/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "91d451608e96b3e06fe98d6bc20915b62eda69ff4fdfdbb2ae9b098eeb11a690"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/typst/hayagriva.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "cli", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hayagriva --version")

    (testpath/"test.yaml").write <<~YAML
      dependence:
          type: Article
          title: The program dependence graph and its use in optimization
          author: ["Ferrante, Jeanne", "Ottenstein, Karl J.", "Warren, Joe D."]
          date: 1987-07
          serial-number:
              doi: "10.1145/24039.24041"
          parent:
              type: Periodical
              title: ACM Transactions on Programming Languages and Systems
              volume: 9
              issue: 3
    YAML

    output = "Ferrante, J., Ottenstein, K. J., & Warren, J. D. (1987)."
    assert_match output, shell_output("#{bin}/hayagriva test.yaml reference --no-fmt --style apa")
  end
end
