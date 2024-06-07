cmake_minimum_required(VERSION 3.0.2)
project(fkie_iop_json_generator)

# Update the policy setting to avoid an error when loading the ament_cmake package
# at the current cmake version level
if(POLICY CMP0057)
    cmake_policy(SET CMP0057 NEW)
endif()

find_package(ament_cmake QUIET)

if ( ament_cmake_FOUND )

    add_definitions( -DUSING_ROS2 )
    message(STATUS "-----------------------------------------\nfkie_iop_json_generator is being built using AMENT.\n-----------------------------------------")

    # Install Python modules
    ament_python_install_package(${PROJECT_NAME})
    include(cmake/jsidl_pyxb.cmake)
    generate_jsidl_pyxb()
    ament_package()

    install(
        PROGRAMS
            scripts/jsidl2json.py
        DESTINATION lib/${PROJECT_NAME}
    )

elseif( CATKIN_DEVEL_PREFIX OR CATKIN_BUILD_BINARY_PACKAGE)

    message(STATUS "------------------------------------------\nfkie_iop_json_generator is being built using CATKIN.\n------------------------------------------")

    find_package(catkin REQUIRED)

    catkin_python_setup()
    include(cmake/jsidl_pyxb.cmake)
    generate_jsidl_pyxb()
    catkin_package()

    catkin_install_python(
        PROGRAMS 
            scripts/jsidl2json.py
        DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
    )

endif()
