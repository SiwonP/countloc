cmake_minimum_required( VERSION 3.6 ) 

project(countloc)

find_package(FLEX)
find_package(BISON)

BISON_TARGET(parser src/parse.y ${CMAKE_CURRENT_BINARY_DIR}/parse.c
    COMPILE_FLAGS -d)
FLEX_TARGET(lexer src/lex.l ${CMAKE_CURRENT_BINARY_DIR}/lex.c)

file(
    GLOB_RECURSE
    source_files
    src/*
)

add_executable(
    countloc
    ${FLEX_lexer_OUTPUTS}
    ${source_files}
)
