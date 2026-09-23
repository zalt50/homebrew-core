class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://launchdarkly.com"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "de175a6481b933af698ae60c252b0d6da5088efac1d9974ab10b4e8cccc197ec"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a32f2cd3b48c15c7000864cf25537ffa5f03b1eab5e636d65d773346db79b6c6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a32f2cd3b48c15c7000864cf25537ffa5f03b1eab5e636d65d773346db79b6c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a32f2cd3b48c15c7000864cf25537ffa5f03b1eab5e636d65d773346db79b6c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "575f843a793ce5e7674fd9dec82b79edc2c48e76b894d820d83529c769026d0e"
    sha256 cellar: :any,                 x86_64_linux:      "d94a6b5e182d8050e4c95b888dd9cb9b83d63bfcc5629fc859a4c4901ac4e459"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/ld-find-code-refs"

    generate_completions_from_executable(bin/"ld-find-code-refs", shell_parameter_format: :cobra)
  end

  test do
    system "git", "init"
    (testpath/"README").write "Testing"
    (testpath/".gitignore").write "Library"
    system "git", "add", "README", ".gitignore"
    system "git", "commit", "-m", "Initial commit"

    assert_match "could not retrieve flag key",
      shell_output("#{bin}/ld-find-code-refs --dryRun \
                   --ignoreServiceErrors -t=xx -p=test -r=test -d=. 2>&1", 1)
  end
end
