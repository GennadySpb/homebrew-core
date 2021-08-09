class DockerMachineDriverYandex < Formula
  desc "Docker Machine driver plugin for Yandex.Cloud"
  homepage "https://cloud.yandex.com"
  url "https://github.com/yandex-cloud/docker-machine-driver-yandex.git",
      tag:      "v0.1.35",
      revision: "02e450490492897b280b993f77a0a27953a101fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "700ee8e5f337ec89182e4585a42929d52a9a56417dd7ee6a5a09bbbc1f38d24b"
    sha256 cellar: :any_skip_relocation, big_sur:       "5028fce4f23eba9047fa977e0db88861d99bcc0dc2b79b0c2920ea68569b970f"
    sha256 cellar: :any_skip_relocation, catalina:      "d0ce7d4804d39392cfede2ecc19fbe763d39b4684306d0cb36efb19359668c53"
    sha256 cellar: :any_skip_relocation, mojave:        "515e8951062268846b9c3ec85aa2b29c6f093cba35eed91a3503344fd5aa288a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfe899d44e93a330c23fb56f24df7b98decb3aa4829f2f69eee63fac804ef8dd"
  end

  depends_on "go" => :build
  depends_on "docker-machine"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    dir = buildpath/"src/github.com/yandex-cloud/docker-machine-driver-yandex"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", "#{bin}/docker-machine-driver-yandex",
             "-ldflags", "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    docker_machine = Formula["docker-machine"].opt_bin/"docker-machine"
    output = shell_output("#{docker_machine} create --driver yandex -h")
    assert_match "engine-env", output
  end
end
