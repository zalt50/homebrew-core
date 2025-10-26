class Vgo < Formula
  desc "Project scaffolder for Go, written in Go"
  homepage "https://github.com/vg006/vgo"
  url "https://github.com/vg006/vgo/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "3a2fee499c91225f2abe1acdb8a640560cda6f4364f4b1aff04756d8ada6282d"
  license "MIT"
  head "https://github.com/vg006/vgo.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"vgo", "completion")
  end

  test do
    expected = if OS.mac?
      "Failed to build the vgo tool"
    else
      "┃ ✔ Built vgo\n┃ ✔ Installed vgo"
    end
    assert_match expected, shell_output("#{bin}/vgo build 2>&1")
  end
end
