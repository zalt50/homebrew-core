class RustypasteCli < Formula
  desc "CLI tool for rustypaste"
  homepage "https://blog.orhun.dev/blazingly-fast-file-sharing"
  url "https://github.com/orhun/rustypaste-cli/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "d12b8acb028a92fc6d16347ce3c4b3fa89c86cb902a4a291c116077cc41b1e92"
  license "MIT"
  head "https://github.com/orhun/rustypaste-cli.git", branch: "master"

  depends_on "rust" => :build
  depends_on "rustypaste" => :test

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "config.toml"
  end

  def caveats
    <<~EOS
      An example config is installed to #{opt_pkgshare}/config.toml
    EOS
  end

  test do
    # Upload error: `invalid file size (status code: 400)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    rustypaste = Formula["rustypaste"]
    cp rustypaste.opt_pkgshare/"config.toml", testpath/"config.toml"
    port = free_port
    address = "127.0.0.1:#{port}"
    inreplace testpath/"config.toml",
              'address = "127.0.0.1:8000"',
              %Q(address = "#{address}")

    (testpath/".config/rustypaste/config.toml").write <<~EOS
      [server]
      address = "http://#{address}"

      [paste]
      oneshot = false
    EOS

    begin
      server = spawn rustypaste.opt_bin/"rustypaste"
      sleep 1

      file = "awesome.txt"
      text = "some text"
      (testpath/file).write text
      url = shell_output("#{bin}/rpaste #{file}").chomp
      assert_equal text, shell_output("curl #{url}")

      text = "Hello World"
      url = pipe_output("#{bin}/rpaste -", text).chomp
      assert_equal text, shell_output("curl #{url}")
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
