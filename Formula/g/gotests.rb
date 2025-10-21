class Gotests < Formula
  desc "Automatically generate Go test boilerplate from your source code"
  homepage "https://github.com/cweill/gotests"
  url "https://github.com/cweill/gotests/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "285cd1afef472abfae577a98020af53aa7600a89b200263207283d348844489e"
  license "Apache-2.0"
  head "https://github.com/cweill/gotests.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10a259b5cb1684f57af33bb5dd0a2ccef63808f2531d8304ea7b530e9fb5373e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10a259b5cb1684f57af33bb5dd0a2ccef63808f2531d8304ea7b530e9fb5373e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10a259b5cb1684f57af33bb5dd0a2ccef63808f2531d8304ea7b530e9fb5373e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4f223b149bd684c8b26e2b5fa6c108a510e96a541a01b189be4dd934a14cb80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac4b3bc5b4fa3ad6ef70b1d9abc26139c441b42b79e0157e961546ba103510af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "889ef45d6601cb599bd65dcadf910e9b16aeeebfe2939cf3dc911d74720fdc1f"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./gotests"
  end

  test do
    (testpath/"test.go").write <<~GO
      package main

      func add(x int, y int) int {
      	return x + y
      }
    GO
    expected = <<~EOS
      Generated Test_add
      package main

      import "testing"

      func Test_add(t *testing.T) {
      	type args struct {
      		x int
      		y int
      	}
      	tests := []struct {
      		name string
      		args args
      		want int
      	}{
      		// TODO: Add test cases.
      	}
      	for _, tt := range tests {
      		t.Run(tt.name, func(t *testing.T) {
      			if got := add(tt.args.x, tt.args.y); got != tt.want {
      				t.Errorf("add() = %v, want %v", got, tt.want)
      			}
      		})
      	}
      }
    EOS
    assert_equal expected, shell_output("#{bin}/gotests -all test.go")
  end
end
