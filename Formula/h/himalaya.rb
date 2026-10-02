class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://pimalaya.org"
  url "https://github.com/pimalaya/himalaya/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "94da785c41d378cf14fb41f62b8e3d6694dd05abdceaaffe36230b74c4d223d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ab78776a5132f4ed04c9532608e630624bb12da21b46c2de3f5d569f3784402e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c016b7bc4d98813a597aec241c4efd314b3f10765b0ee89aa4cdb8a32688f768"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ff375d703421c90a036403f6ea8c779ca13d86951f6d0743cf638b6d15b7df45"
    sha256 cellar: :any,                 arm64_linux:       "d4644cd1ed5a5bf26e2ff223d63aaae75040b9783c2e09f0ecd0a93c3ed083a6"
    sha256 cellar: :any,                 x86_64_linux:      "cff791a0dc47dd9054db554ee10bae4f5d44783376bea4fed30c4bd63c0ca18b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    system bin/"himalaya", "manual", "--dir", buildpath
    man1.install Dir["*.1"]
    generate_completions_from_executable(bin/"himalaya", "completion")
  end

  test do
    # See https://github.com/pimalaya/himalaya#configuration
    (testpath/".config/himalaya/config.toml").write <<~TOML
      [accounts.gmail]
      default = true
      email = "example@gmail.com"

      folder.alias.inbox = "INBOX"
      folder.alias.sent = "[Gmail]/Sent Mail"
      folder.alias.drafts = "[Gmail]/Drafts"
      folder.alias.trash = "[Gmail]/Trash"

      backend.type = "imap"
      backend.host = "imap.gmail.com"
      backend.port = 993
      backend.login = "example@gmail.com"
      backend.auth.type = "password"
      backend.auth.raw = "*****"

      message.send.backend.type = "smtp"
      message.send.backend.host = "smtp.gmail.com"
      message.send.backend.port = 465
      message.send.backend.login = "example@gmail.com"
      message.send.backend.auth.type = "password"
      message.send.backend.auth.cmd = "*****"
    TOML

    assert_match "gmail", shell_output("#{bin}/himalaya account list")
  end
end
