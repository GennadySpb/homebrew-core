class DockerMachineDriverYandex < Formula
  desc "Docker Machine driver plugin for Yandex.Cloud"
  homepage "https://cloud.yandex.com"
  url "https://github.com/yandex-cloud/docker-machine-driver-yandex.git",
      tag:      "v0.1.35",
      revision: "02e450490492897b280b993f77a0a27953a101fc"
  license "MIT"

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
