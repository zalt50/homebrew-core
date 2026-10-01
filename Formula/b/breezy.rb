class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  homepage "https://www.breezy-vcs.org/"
  url "https://files.pythonhosted.org/packages/59/1d/68956e351c1af8116ec8525c85faf82ed2484f38f6f4fed4755759073500/breezy-3.3.21.tar.gz"
  sha256 "70a5a810690ad8d5def1798a1351e7588be7f89f821eb7a6fae277aacd33d3be"
  license "GPL-2.0-or-later"
  revision 4
  head "https://github.com/breezy-team/breezy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "de34a6172a3b2bb9c2a3de1fe9f8858a9a180872f9fb4d72f087d64db3aaaf96"
    sha256 cellar: :any, arm64_tahoe:       "4415490b76c95a8144d4effcfa4bd5155744ed92d0110232d9b38bb2f8821038"
    sha256 cellar: :any, arm64_sequoia:     "76944202e7daf48d340c56f6961184b6cefa269f121c973c92fe7008ec81ffdd"
    sha256 cellar: :any, arm64_sonoma:      "d7486b073f4210911914984658fb90acb5691ca86560a576674996c34c458b0e"
    sha256 cellar: :any, sonoma:            "ffe03ab0855bcbdecd5e99b07ffaea9b84f79ec0829cad715a95a46e54ef0933"
    sha256 cellar: :any, arm64_linux:       "b430dbd6acbb55b57c612f788134910e892b99aa1d5b94ceb0e559b2776996a3"
    sha256 cellar: :any, x86_64_linux:      "5feaf5b837b4838092680c96370fb89a611504632c5292b4ba70c15f492c65a8"
  end

  depends_on "gettext" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/63/b9/5b68d879282190b0429c815d582dc1f212d4910aa22ac7c1aff39675a719/dulwich-1.2.15.tar.gz"
    sha256 "e98f775601846fb4d44a384003e93c53c42b0c9796c8fe0cc3128b8e2e0bbf88"
  end

  resource "fastbencode" do
    url "https://files.pythonhosted.org/packages/57/ce/70e4db33a5393433ff45c5307e616127807735faff4d12f002c20de16688/fastbencode-0.3.11.tar.gz"
    sha256 "7e2be45bfe81167cd79986698a2cf270eaf61add5b1bc711378c2bb3f05396d5"
  end

  resource "merge3" do
    url "https://files.pythonhosted.org/packages/12/71/daaa7978561b9a7bfdcee4ba5ec2ead6162f6a9d2e2edf069def96085c6b/merge3-0.0.16.tar.gz"
    sha256 "0852de4381cb46be5ef4ed49e3ac20c5a4a0cd46a8ff4bbb870bc27aab543306"
  end

  resource "patiencediff" do
    url "https://files.pythonhosted.org/packages/58/5c/effa27de2f2251a02051f5546ee9f9ceae7c2d15dadaadae5dbe6ee890e1/patiencediff-0.2.19.tar.gz"
    sha256 "a060953edd05521e6368245d6c70402308a7aea4f66a706b2d832721d1375679"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    virtualenv_install_with_resources
    bin.each_child do |f|
      f.unlink
      f.write_env_script libexec/"bin"/f.basename, PATH: "#{libexec}/bin:$PATH"
    end

    # Replace bazaar with breezy
    bin.install_symlink "brz" => "bzr"
  end

  test do
    whoami = "Homebrew <homebrew@example.com>"
    system bin/"brz", "whoami", whoami
    assert_match whoami, shell_output("#{bin}/brz whoami")

    # Test bazaar compatibility
    system bin/"brz", "init-repo", "sample"
    system bin/"brz", "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"
    cd "sample/trunk" do
      system bin/"brz", "add", "test.txt"
      system bin/"brz", "commit", "-m", "test"
    end

    # Test git compatibility
    system bin/"brz", "init", "--git", "sample2"
    touch testpath/"sample2/test.txt"
    cd "sample2" do
      system bin/"brz", "add", "test.txt"
      system bin/"brz", "commit", "-m", "test"
    end
  end
end
