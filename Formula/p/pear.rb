class Pear < Formula
  desc "Peer-to-peer application runtime"
  homepage "https://docs.pears.com"
  url "https://registry.npmjs.org/pear/-/pear-3.0.0.tgz"
  sha256 "5f45f33e4dabf589392ca6fe7ea28eda546069a3d3e946fa58080191a419f02c"
  license "Apache-2.0"
  head "https://github.com/holepunchto/pear.git", branch: "main"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    libexec.glob("lib/node_modules/pear/node_modules/**/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    ENV["HOME"] = testpath

    pear = testpath/".local/bin/pear"
    pear.dirname.mkpath
    pear.write <<~SH
      #!/bin/sh
      [ "$1" = "touch" ] && [ "$2" = "--json" ] || exit 1
      echo '{"cmd":"touch","tag":"final","data":{"success":true,"link":"pear://#{"a" * 52}"}}'
    SH
    pear.chmod 0755

    result = JSON.parse(shell_output("#{bin}/pear touch --json"))
    assert_equal "touch", result["cmd"]
    assert_equal "final", result["tag"]
    assert result.dig("data", "success")
    assert_match %r{\Apear://[a-z0-9]{52}\z}, result.dig("data", "link")
  end
end
