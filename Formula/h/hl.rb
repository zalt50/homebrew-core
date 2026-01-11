class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https://github.com/pamburus/hl"
  url "https://github.com/pamburus/hl/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "54048a390ef7762d0b2bfac8941fe91bb195d17d461faaf4414fc704d128f187"
  license "MIT"
  head "https://github.com/pamburus/hl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b633829c981148979a879b52c30f04cf37a16d82c6d2a0f84176dca223b889e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e790dadf7ea90ac216d4fbdf6791d1dddec7299b00828b361fc6d387f6ffef5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fce5f507b88727fdce3bdfb5b8d941785b779f46e569854cbf11ea37bf2693b"
    sha256 cellar: :any_skip_relocation, sonoma:        "59f6c42c6ee907a1b7d5dd6a1812468858e15c52dd68faae655fd1e1937a96a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ced14ef640370f57c152d3c61a82f7db9d3cd84246630aeba1ae0789b8989de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c70e75abec2b69a4c1119eee34da7ed6419a7f0f993e41f5a1f4868790ecf1d0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hl", "--shell-completions")
    (man1/"hl.1").write Utils.safe_popen_read(bin/"hl", "--man-page")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hl --version")

    (testpath/"sample.log").write <<~EOS
      time="2025-02-17 12:00:00" level=INFO msg="Starting process"
      time="2025-02-17 12:01:00" level=ERROR msg="An error occurred"
      time="2025-02-17 12:02:00" level=INFO msg="Process completed"
    EOS

    output = shell_output("#{bin}/hl --level ERROR sample.log")
    assert_equal "Feb 17 12:01:00.000 [ERR] An error occurred", output.chomp
  end
end
