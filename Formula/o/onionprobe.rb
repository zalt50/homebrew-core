class Onionprobe < Formula
  include Language::Python::Virtualenv

  desc "Test and monitoring tool for Tor Onion Services"
  homepage "https://tpo.pages.torproject.net/onion-services/onionprobe/"
  url "https://files.pythonhosted.org/packages/54/5c/cd134dc632131ad3e88bae3c28cacf15443fc76541f731c184f171a54e83/onionprobe-1.4.0.tar.gz"
  sha256 "ae3131326d669287918aff9a36e0ba21ea34fd7e6c6ec8ee4a20077274318c5a"
  license "GPL-3.0-or-later"
  head "https://gitlab.torproject.org/tpo/onion-services/onionprobe.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "81621589fe463b9ca930d0b4d7e574b12a74b46a392712d8079c00dfa49102be"
    sha256 cellar: :any,                 arm64_sequoia: "6827f95de7ece5a165888562052621589c3f0dad6def3bf1659367152d1ef05e"
    sha256 cellar: :any,                 arm64_sonoma:  "a60e98ac2e06c91223922ea176967b3789ba1e8a6f5cf0045d38ad85f17e1e0a"
    sha256 cellar: :any,                 sonoma:        "c364a4fb1d477a8c5ffcf55868c4e22f5c6ee006c981b59526a4ffae371f0607"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcc1b0a72418a251f5d170ce859bcc5ec91e804234a84426f60c43ed7b4b6eda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83bdb2939b2d933b887cefa17156d2a11f889bbd633e8f43d36a7dfd1c804deb"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tor"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/23/53/3edb5d68ecf6b38fcbcc1ad28391117d2a322d9a1a3eff04bfdb184d8c3b/prometheus_client-0.23.1.tar.gz"
    sha256 "6ae8f9081eaaaf153a2e959d2e6c4f4fb57b12ef76c8c7980202f1e57b48b2ce"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "stem" do
    url "https://files.pythonhosted.org/packages/94/c6/b2258155546f966744e78b9862f62bd2b8671b422bb9951a1330e4c8fd73/stem-1.8.2.tar.gz"
    sha256 "83fb19ffd4c9f82207c006051480389f80af221a7e4783000aedec4e384eb582"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  # Fix to support Python 3.14
  # Issue ref: https://gitlab.torproject.org/tpo/onion-services/onionprobe/-/issues/116
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/onionprobe --version")

    output = shell_output("#{bin}/onionprobe -e 2gzyxa5ihm7nsggfxnu52rck2vv4rvmdlkiu3zzui5du4xyclen53wid.onion 2>&1")
    assert_match "Status code is 200", output
  end
end

__END__
diff --git a/packages/onionprobe/config.py b/packages/onionprobe/config.py
index 9414f3f..bb9c832 100644
--- a/packages/onionprobe/config.py
+++ b/packages/onionprobe/config.py
@@ -277,7 +277,13 @@ def cmdline_parser():
             parser.add_argument('-e', '--endpoints', nargs='*', help='Add endpoints to the test list', metavar="ONION-ADDRESS1")
 
         else:
-            config[argument]['type'] = type(config[argument]['default'])
+            import argparse as _argparse
+            if isinstance(config[argument].get('default'), bool):
+                config[argument].pop('type', None)
+                config[argument].pop('metavar', None)
+                config[argument]['action'] = _argparse.BooleanOptionalAction
+            else:
+                config[argument]['type'] = type(config[argument]['default'])
 
             if not isinstance(config[argument]['default'], bool) and config[argument]['default'] != '':
                 config[argument]['help'] += ' (default: %(default)s)'
