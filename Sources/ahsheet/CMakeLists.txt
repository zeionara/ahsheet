add_library(ahsheet
    Address.swift
)
# NOTE: workaround for CMake not setting up include flags yet
set_target_properties(ahsheet PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options(ahsheet PRIVATE
  $<$<BOOL:${BUILD_TESTING}>:-enable-testing>)
target_link_libraries(ahsheet PRIVATE
  $<$<NOT:$<PLATFORM_ID:Darwin>>:Foundation>)


_install_target(ahsheet)
set_property(GLOBAL APPEND PROPERTY ahsheet_EXPORTS ahsheet)
