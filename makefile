BUILD_DIR?=$(PWD)/build
DEPENDENCY_DIR=$(PWD)/Dependencies

MKDIR_P = mkdir -p

.PHONY: directories

include $(PWD)/Dependencies/GrovePi/makefile

all: directories hello

hello: GrovePi
	swiftc GrovePiTests.swift -import-objc-header $(BUILD_DIR)/bridge.h -L $(BUILD_DIR) -lgrovepi -lcgrovepi  -I $(BUILD_DIR) -o ./build/grovepitests

directories: ${OUT_DIR}

${OUT_DIR}:
	${MKDIR_P} $(BUILD_DIR)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
