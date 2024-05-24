cmake_minimum_required(VERSION 3.16)

project(TasmotaControl-plasmoid)

find_package(ECM 1.4.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

find_package(Plasma) # Required for plasma_install_package()

plasma_install_package(package com.luk.tasmotacontrol)
