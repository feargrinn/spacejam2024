.PHONY: clean project linux web windows all

all: linux web windows

clean:
	rm -rf release/*

GAME_NAME := Iks
PROJECT_DIR := $(CURDIR)/game
OUTPUT_DIR := $(CURDIR)/release
FILE_PREFIX := $(OUTPUT_DIR)/$(GAME_NAME)
PCK_FILE := $(FILE_PREFIX).pck
LINUX_EXECUTABLE := $(FILE_PREFIX).x86_64
LINUX_ZIP := $(FILE_PREFIX)_linux.zip
WEB_EXECUTABLE := $(FILE_PREFIX).html
WEB_FILES := $(addprefix $(FILE_PREFIX),.apple-touch-icon.png .audio.worklet.js .icon.png  .js .png .wasm .worker.js)
WEB_ZIP := $(FILE_PREFIX)_web.zip
WINDOWS_EXECUTABLE := $(FILE_PREFIX).exe
WINDOWS_ZIP := $(FILE_PREFIX)_windows.zip

$(LINUX_EXECUTABLE): $(PROJECT_DIR)/*
	godot4 --headless --path $(PROJECT_DIR) --export-release "Linux/X11"  $@

$(WEB_EXECUTABLE): $(PROJECT_DIR)/*
	godot4 --headless --path $(PROJECT_DIR) --export-release "Web"  $@

$(WINDOWS_EXECUTABLE): $(PROJECT_DIR)/*
	godot4 --headless --path $(PROJECT_DIR) --export-release "Windows Desktop"  $@

$(LINUX_ZIP): $(LINUX_EXECUTABLE) $(PCK_FILE)
	zip -j $(LINUX_ZIP) $(PCK_FILE) $(LINUX_EXECUTABLE)

$(WEB_ZIP): $(WEB_EXECUTABLE) $(WEB_FILES) $(PCK_FILE)
	cp $(WEB_EXECUTABLE) $(OUTPUT_DIR)/index.html
	zip -j $(WEB_ZIP) $(OUTPUT_DIR)/index.html $(WEB_FILES) $(PCK_FILE)

$(WINDOWS_ZIP): $(WINDOWS_EXECUTABLE) $(PCK_FILE)
	zip -j $(WINDOWS_ZIP) $(PCK_FILE) $(WINDOWS_EXECUTABLE)

linux: $(LINUX_ZIP)

web: $(WEB_ZIP)

windows: $(WINDOWS_ZIP)
