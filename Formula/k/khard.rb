class Khard < Formula
  include Language::Python::Virtualenv

  desc "Console carddav client"
  homepage "https://khard.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/8f/47/e31cf968dbbba341887dd33bb84fd1ecba737bc762a5149c9c673f1ab6da/khard-0.21.0.tar.gz"
  sha256 "67a99a4655ceec9520ec4bb282845f83cc6c6efd29daf9b3208e5ed50270affb"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5518339fb9e38d369d0f5c16dde65f96e628e66fee456fabb2b1f1300146f270"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d369c1710a688b2d4b88ffb4ae7722e1856ee365ab832cbd02fd96caec98831"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bb265a3d491639f98b2d79a922ca6d9a2d64984eabb20771593f1e518e9aa88"
    sha256 cellar: :any_skip_relocation, sonoma:        "b36a867168a0ec439838d2f400c20f3c5601190ae0f43906635fd3e6cd24383d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edcb3d36eaec81549a894614250bd2a1c9fe32aca283f04a804bd8f9cde9cf35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d06c2fe4f7dc9be8bae61d3572bc77e670aebefc93c84e23f74a97376aa65f5"
  end

  depends_on "python@3.14"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/ff/46/dd499ec9038423421951e4fad73051febaa13d2df82b4064f87af8b8c0c3/pytz-2026.2.tar.gz"
    sha256 "0e60b47b29f21574376f218fe21abc009894a2321ea16c6754f3cad6eb7cdd6a"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "vobject" do
    url "https://files.pythonhosted.org/packages/d0/8a/15c34b3d27c43fc81a467d0f66577afc5542326804c42f30557e31c3259e/vobject-0.9.9.tar.gz"
    sha256 "ac44e5d7e2079d84c1d52c50a615b9bec4b1ba958608c4c7fe40cbf33247b38e"
  end

  def install
    venv = virtualenv_install_with_resources without: "vobject"

    # Workaround broken dynamic version: https://github.com/py-vobject/vobject/issues/121
    # Upstream has unreleased fix by migrating to pyproject.toml
    # https://github.com/py-vobject/vobject/commit/6d907ee2c986b065794c3a50afdfb5f5677830f1
    resource("vobject").stage do |r|
      inreplace "setup.cfg", "attr: vobject.VERSION", r.version.to_s
      venv.pip_install Pathname.pwd
    end

    (etc/"khard").install "doc/source/examples/khard.conf.example"
    zsh_completion.install "misc/zsh/_khard"
    pkgshare.install (buildpath/"misc").children - [buildpath/"misc/zsh"]
  end

  test do
    (testpath/".config/khard/khard.conf").write <<~EOS
      [addressbooks]
      [[default]]
      path = ~/.contacts/
      [general]
      editor = /usr/bin/vi
      merge_editor = /usr/bin/vi
      default_country = Germany
      default_action = list
      show_nicknames = yes
    EOS
    (testpath/".contacts/dummy.vcf").write <<~EOS
      BEGIN:VCARD
      VERSION:3.0
      EMAIL;TYPE=work:username@example.org
      FN:User Name
      UID:092a1e3b55
      N:Name;User
      END:VCARD
    EOS
    assert_match "Address book: default", shell_output("#{bin}/khard list user")
  end
end
