include(CMakeParseArguments)

macro(generate_jsidl_pyxb)
    find_program(PYXBGEN_BIN NAMES pyxbgen pyxbgen-py3 HINTS $ENV{HOME}/.local/bin)
    if (NOT ${CATKIN_DEVEL_PREFIX})
        # ros1
        if ( EXISTS ${CATKIN_DEVEL_PREFIX}/lib/python3)
            set(PYXB_GENERATED_SRC_DIR "${CATKIN_DEVEL_PREFIX}/lib/python3/dist-packages/jsidl_pyxb")
        else()
            set(PYXB_GENERATED_SRC_DIR "${CATKIN_DEVEL_PREFIX}/lib/python3.8/site-packages/jsidl_pyxb")
        endif()
    elseif (NOT ${CMAKE_INSTALL_PREFIX})
        # ros2
        if ( EXISTS ${CMAKE_INSTALL_PREFIX}/lib/python3)
            set(PYXB_GENERATED_SRC_DIR "${CMAKE_INSTALL_PREFIX}/lib/python3/dist-packages/jsidl_pyxb")
        else()
            set(PYXB_GENERATED_SRC_DIR "${CMAKE_INSTALL_PREFIX}/lib/python3.8/site-packages/jsidl_pyxb")
        endif()
    else ()
        set(PYXB_GENERATED_SRC_DIR "generated_pyxb/jsidl_pyxb")
    endif()
    message(STATUS "PYXB_GENERATED_SRC_DIR: ${PYXB_GENERATED_SRC_DIR}")
    get_filename_component(PYXB_GENERATED_SRC_DIR "${PYXB_GENERATED_SRC_DIR}" PATH)
    # set(PYXB_GENERATED_SRC_DIR "${PROJECT_SOURCE_DIR}/src/${PROJECT_NAME}")
    # cmake_parse_arguments(proto_arg "" "" "JSIDL_FILES" ${ARGN})
    # message(STATUS "jsidl pyxb files: ${proto_arg_JSIDL_FILES}")
    # set(PYXB_GENERATED_SOURCES "")
    set(ABS_XSD_PATH "${PROJECT_SOURCE_DIR}/xsd")
    # command to create generated directory
    add_custom_command(
        OUTPUT ${PYXB_GENERATED_SRC_DIR}
        COMMAND ${CMAKE_COMMAND} -E make_directory "${PYXB_GENERATED_SRC_DIR}"
        COMMENT "create directory for generated pyxb code: ${CMAKE_CURRENT_SOURCE_DIR}"
    )
    message(STATUS "destination for pyxb generated code: ${PYXB_GENERATED_SRC_DIR}")
    set(ABS_XSD_FILE "${ABS_XSD_PATH}/jsidl_plus_v0.xsd")
    set(ABS_GEN_FILE "${PYXB_GENERATED_SRC_DIR}/${PROJECT_NAME}/jsidl_pyxb/jsidl.py")
    message(STATUS "generate python code from ${ABS_XSD_FILE}")
    add_custom_command(
        OUTPUT ${ABS_GEN_FILE}
        COMMAND "${PYXBGEN_BIN}" -u ${ABS_XSD_FILE} --schema-root=${ABS_XSD_PATH} --binding-root=${PYXB_GENERATED_SRC_DIR} --module-prefix="${PROJECT_NAME}.jsidl_pyxb" -m jsidl
        DEPENDS ${ABS_XSD_FILE}
    )
#        COMMENT "${PYXBGEN_BIN} -u ${ABS_XSD_FILE} --schema-root=${ABS_XSD_PATH} --binding-root=${PYXB_GENERATED_SRC_DIR} -m jsidl"
    # create init file
    add_custom_target(
        ${PROJECT_NAME}_PYXB ALL
        DEPENDS ${ABS_GEN_FILE}
    )
       #COMMAND ${CMAKE_COMMAND} -E touch "${PYXB_GENERATED_SRC_DIR}/jsidl_pyxb/__init__.py"
        #COMMENT "Create '__init__.py' for generated jsidl_pyxb module"
endmacro()
