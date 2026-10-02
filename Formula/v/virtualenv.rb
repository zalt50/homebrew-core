class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/01/59/5ebdaa984350ae7ef1dc14b4d0bd618f6e0d3fb13e7b336939433eebf37b/virtualenv-21.14.3.tar.gz"
  sha256 "cb5cd3a87f12a6cfdc0cef6bc8bead6138221767f7718e0c00fee5fb907f9858"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5fa0e21333f3cce4a7ade78b5802f986458de02ba6afe64017366440af161c69"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5fa0e21333f3cce4a7ade78b5802f986458de02ba6afe64017366440af161c69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5fa0e21333f3cce4a7ade78b5802f986458de02ba6afe64017366440af161c69"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4d0a5edc0c9629697b652713f72c7ec3fcc6f3105e3808b13df3ef9ae1b39b4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4d0a5edc0c9629697b652713f72c7ec3fcc6f3105e3808b13df3ef9ae1b39b4a"
  end

  depends_on "python@3.14"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/51/2bc9e529f154fad99b6cd0073e609291eb32fd23581b32362d33d164d316/filelock-4.0.9.tar.gz"
    sha256 "635e7d67fa92654eed444e75e9ca18426d34e77ad9c469bf4373f75a932f7b22"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/17/c8/721b3855fe457da514fe249247d404b9b39c5d16532278f70ebaa6acf18b/platformdirs-4.12.2.tar.gz"
    sha256 "eab5f70271a490ef74618bb314fbb86e3c7e82fa3b9c922c2ea0e0a1a155d329"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/0c/57/250bd238b966cece44328235eb85290045d059265fdaf7527a3a958123db/python_discovery-1.6.1.tar.gz"
    sha256 "cf87d3627dfb4412437fdd5b13eae402607722998d21567993aedbc59b23c15e"
  end

  allow_network_access! :build

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
