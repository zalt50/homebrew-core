class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.en.dev"
  url "https://github.com/endevco/pitchfork/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "3c903458db95d208ad8852b938a272eb9fde005223c5e3867ea10fe9daa2e424"
  license "MIT"
  head "https://github.com/endevco/pitchfork.git", branch: "main"

  depends_on "rust" => :build
  depends_on "usage"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"pitchfork", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitchfork --version")

    system bin/"pitchfork", "config", "add", "brewtest", "--run", "echo brewed", "--ready-output", "brewed"
    config = (testpath/"pitchfork.toml").read
    assert_match 'run = "echo brewed"', config
    assert_match 'ready_output = "brewed"', config
  end
end
