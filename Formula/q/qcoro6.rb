class Qcoro6 < Formula
  desc "C++ Coroutines for Qt"
  homepage "https://qcoro.dev"
  url "https://github.com/qcoro/qcoro/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "809afafab61593f994c005ca6e242300e1e3e7f4db8b5d41f8c642aab9450fbc"
  license "MIT"

  depends_on "cmake" => [:build, :test]
  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtwebsockets"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DQCORO_BUILD_EXAMPLES=OFF",
                    "-DQCORO_BUILD_TESTING=OFF",
                    "-DUSE_QT_VERSION=6",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.16)
      project(QCoroTest LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 20)
      find_package(QCoro6 REQUIRED COMPONENTS Coro Core Network WebSockets Quick Qml Test)
      find_package(Qt6 REQUIRED COMPONENTS Core Network WebSockets Quick Qml Test)
      add_executable(testapp test.cpp)
      target_link_libraries(testapp PRIVATE
        QCoro6::Coro
        QCoro6::Core Qt6::Core
        QCoro6::Network Qt6::Network
        QCoro6::WebSockets Qt6::WebSockets
        QCoro6::Quick Qt6::Quick
        QCoro6::Qml Qt6::Qml
        QCoro6::Test Qt6::Test)
      qcoro_enable_coroutines()
    CMAKE

    (testpath/"test.cpp").write <<~CPP
      #include <QCoroTask> // from QCoroCoro
      #include <QCoroSignal> // from QCoroCore
      #include <QCoroAbstractSocket> // from QCoroNetwork
      #include <QCoroWebSocket> // from QCoroWebSockets
      #include <QCoroImageProvider> // from QCoroQuick
      #include <QCoroQmlTask> // from QCoroQml
      #include <QCoroTest> // from QCoroTest
      int main(int argc, char **argv) {
        QCoro::Task<int> t = []() -> QCoro::Task<int> { co_return 42; }();
        return 0;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    system "./build/testapp"
  end
end
