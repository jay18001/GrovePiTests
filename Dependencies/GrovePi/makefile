BUILD_DIR?=./Build

SOURCE_DIR=$(DEPENDENCY_DIR)/GrovePi

MKDIR_P = mkdir -p

.PHONY: directories
.PHONY: copyheaders

GrovePi: libcgrovepi.a copyheaders
	mkdir -p $(BUILD_DIR)/GrovePi
	swiftc $(SOURCE_DIR)/*.swift -import-objc-header $(SOURCE_DIR)/CGrovePi/bridge.h -L$(BUILD_DIR) -lcgrovepi -emit-module-path $(BUILD_DIR)/GrovePi -emit-module -module-name GrovePi
	swiftc $(SOURCE_DIR)/*.swift -import-objc-header $(SOURCE_DIR)/CGrovePi/bridge.h -L$(BUILD_DIR) -lcgrovepi -whole-module-optimization -o $(BUILD_DIR)/GrovePi -emit-object -module-name GrovePi
	ar rcs $(BUILD_DIR)/libgrovepi.a $(BUILD_DIR)/GrovePi/*.o
	cp $(BUILD_DIR)/GrovePi/GrovePi.swiftmodule $(BUILD_DIR)/GrovePi.swiftmodule

libcgrovepi.a: cgrovepi.o
	ar -rc $(BUILD_DIR)/libcgrovepi.a $(BUILD_DIR)/CGrovePi/cgrovepi.o
	ranlib $(BUILD_DIR)/libcgrovepi.a

cgrovepi.o: $(SOURCE_DIR)/CGrovePi/grovepi.c $(SOURCE_DIR)/CGrovePi/grovepi.h
	mkdir -p $(BUILD_DIR)/CGrovePi
	gcc -c $(SOURCE_DIR)/CGrovePi/grovepi.c -o $(BUILD_DIR)/CGrovePi/cgrovepi.o

copyheaders:
	cp $(SOURCE_DIR)/CGrovePi/bridge.h $(BUILD_DIR)/bridge.h
	cp $(SOURCE_DIR)/CGrovePi/grovepi.h $(BUILD_DIR)/grovepi.h

directories: ${OUT_DIR}

${OUT_DIR}:
	${MKDIR_P} $(BUILD_DIR)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
