vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://gitee.com/zhang-qingru/gloves_sdk.git
    REF a9a4f9f98ce951f57df05248b8fe5eef1ba598b5
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DFULAI_TACTILE_BUILD_TESTS=OFF
        -DFULAI_TACTILE_BUILD_EXAMPLES=OFF
        -DFULAI_TACTILE_BUILD_TOOLS=OFF
        -DFULAI_TACTILE_QT_REFERENCE_TESTS=OFF
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(
    PACKAGE_NAME FulaiTactile
    CONFIG_PATH lib/cmake/FulaiTactile
)
vcpkg_copy_pdbs()

# The upstream install also ships source examples and documentation at the
# prefix root. Keep one release copy under share and remove debug duplicates.
file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/share/${PORT}")
foreach(metadata README.md README.en.md THIRD_PARTY.md CHANGELOG.md)
    if(EXISTS "${CURRENT_PACKAGES_DIR}/${metadata}")
        file(RENAME
            "${CURRENT_PACKAGES_DIR}/${metadata}"
            "${CURRENT_PACKAGES_DIR}/share/${PORT}/${metadata}")
    endif()
endforeach()
foreach(directory docs examples)
    if(EXISTS "${CURRENT_PACKAGES_DIR}/${directory}")
        file(RENAME
            "${CURRENT_PACKAGES_DIR}/${directory}"
            "${CURRENT_PACKAGES_DIR}/share/${PORT}/${directory}")
    endif()
endforeach()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/tools"
    "${CURRENT_PACKAGES_DIR}/licenses"
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
    "${CURRENT_PACKAGES_DIR}/debug/examples"
    "${CURRENT_PACKAGES_DIR}/debug/tools"
    "${CURRENT_PACKAGES_DIR}/debug/docs"
    "${CURRENT_PACKAGES_DIR}/debug/licenses"
)
file(REMOVE
    "${CURRENT_PACKAGES_DIR}/LICENSE"
    "${CURRENT_PACKAGES_DIR}/debug/README.md"
    "${CURRENT_PACKAGES_DIR}/debug/README.en.md"
    "${CURRENT_PACKAGES_DIR}/debug/LICENSE"
    "${CURRENT_PACKAGES_DIR}/debug/THIRD_PARTY.md"
    "${CURRENT_PACKAGES_DIR}/debug/CHANGELOG.md"
)

vcpkg_install_copyright(FILE_LIST
    "${SOURCE_PATH}/LICENSE"
    "${SOURCE_PATH}/third_party/nlohmann/LICENSE.MIT"
)
