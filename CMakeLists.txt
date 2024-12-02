cmake_minimum_required(VERSION 3.14)
project(fasttext_server)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Threads REQUIRED)

include(FetchContent)

FetchContent_Declare(
    fastText
    GIT_REPOSITORY https://github.com/facebookresearch/fastText.git
    GIT_TAG v0.9.2
)
FetchContent_MakeAvailable(fastText)

FetchContent_Declare(
    httplib
    GIT_REPOSITORY https://github.com/yhirose/cpp-httplib.git
    GIT_TAG v0.14.1
)
FetchContent_MakeAvailable(httplib)

set(CMAKE_BUILD_TYPE Release)
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

add_executable(fasttext_lid_server main.cpp)
target_include_directories(fasttext_lid_server PRIVATE ${fasttext_SOURCE_DIR}/src)

target_link_libraries(fasttext_lid_server
    fasttext-static
    httplib::httplib
    Threads::Threads
)
