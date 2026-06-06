class Opal < Formula
  desc "Ruby to JavaScript transpiler"
  homepage "https://opalrb.com/"
  url "https://github.com/opal/opal.git",
      tag:      "v1.8.3",
      revision: "54a8bbbf582458b66ab3b52e68bbf2b73281751a"
  license "MIT"
  head "https://github.com/opal/opal.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "d0e1b504e4fd8a90d061deebf3b7d196179cfc538408ec6b70a25634a31a6659"
    sha256                               arm64_sequoia: "05ae63334332a7cbbfabb7754b46cf02b1611eed1c6759d0452c0e1c723c06f6"
    sha256                               arm64_sonoma:  "ac6753b6913583f8c9f2b3a32f457ab4baecdf39bacd7ed05b68e99a1a1ab5ff"
    sha256                               sonoma:        "49c4fab7a77ec600a1234f7a3c4313cb1082e1641b21c764f9c9322b4da55226"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64a42c290b13d6f172e933b2b5433babf4f607dd818d55ce276f9bef95a04d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64a42c290b13d6f172e933b2b5433babf4f607dd818d55ce276f9bef95a04d61"
  end

  depends_on "quickjs" => :test
  depends_on "ruby"

  # List with `gem install --explain opal --platform ruby -v #{version}`
  resource "racc" do
    url "https://rubygems.org/gems/racc-1.8.1.gem"
    sha256 "4a7f6929691dbec8b5209a0b373bc2614882b55fc5d2e447a21aaa691303d62f"
  end

  resource "ast" do
    url "https://rubygems.org/gems/ast-2.4.3.gem"
    sha256 "954615157c1d6a382bc27d690d973195e79db7f55e9765ac7c481c60bdb4d383"
  end

  resource "parser" do
    url "https://rubygems.org/gems/parser-3.3.11.1.gem"
    sha256 "d17ace7aabe3e72c3cc94043714be27cc6f852f104d81aa284c2281aecc65d54"
  end

  resource "base64" do
    url "https://rubygems.org/gems/base64-0.3.0.gem"
    sha256 "27337aeabad6ffae05c265c450490628ef3ebd4b67be58257393227588f5a97b"
  end

  def install
    ENV["GEM_HOME"] = libexec

    resources.each do |r|
      system "gem", "install", r.cached_download, "--ignore-dependencies", "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "#{name}-#{version}.gem"
    %w[opal opal-build opal-repl].each do |program|
      bin.install libexec/"bin/#{program}"
    end
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    (testpath/"test.rb").write "puts 'Hello world!'"
    assert_equal "Hello world!", shell_output("#{bin}/opal --runner quickjs test.rb").strip

    system bin/"opal", "--compile", "test.rb", "--output", "test.js"
    assert_equal "Hello world!", shell_output("#{Formula["quickjs"].opt_bin}/qjs test.js").strip
  end
end
