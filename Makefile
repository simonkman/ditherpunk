VERSION := $(shell git describe --tags --abbrev=0)
OUT_DIR := out
PACK_FILENAME := ditherpunk_$(VERSION).zip
OUTPATH := $(OUT_DIR)/$(PACK_FILENAME)

all: clean shaderpack

shaderpack: LICENSE README.md $(wildcard shaders/*)
	zip -r $(OUTPATH) LICENSE README.md shaders/

clean:
	rm -f $(OUTPATH)
