require File.expand_path("../Abstract/abstract-osquery-formula", __FILE__)

class CppNetlib < AbstractOsqueryFormula
  desc "C++ libraries for high level network programming"
  homepage "http://cpp-netlib.org"
  url "https://github.com/cpp-netlib/cpp-netlib/archive/cpp-netlib-0.12.0-final.tar.gz"
  version "0.12.0"
  sha256 "d66e264240bf607d51b8d0e743a1fa9d592d96183d27e2abdaf68b0a87e64560"

  bottle do
    root_url "https://osquery-packages.s3.amazonaws.com/bottles"
    cellar :any_skip_relocation
    sha256 "63381c4bcf64028c92aaaf51df8637b1d3ab5ffd3a3c30736c04361c2e08af6a" => :el_capitan
    sha256 "e906fa8d5347a923fffe6443a8ec1346a6e798ed7bf6071b5a002958d25eca3a" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  needs :cxx11

  def install
    ENV.cxx11

    args = [
      "-DCPP-NETLIB_BUILD_TESTS=OFF",
      "-DCPP-NETLIB_BUILD_EXAMPLES=OFF",
    ]

    # NB: Do not build examples or tests as they require submodules.
    args += std_cmake_args
    system "cmake", *args
    system "make"
    system "make", "install"

    # Move lib64/* to lib/ on Linuxbrew
    lib64 = Pathname.new "#{lib}64"
    if lib64.directory?
      mkdir_p lib
      system "mv #{lib64}/* #{lib}/"
      rmdir lib64
    end
  end
end
