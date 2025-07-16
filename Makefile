all: clean shaderpack

shaderpack: LICENSE README.md $(wildcard shaders/*)
	zip -r ditherpunk.zip LICENSE README.md shaders/

clean:
	rm -f ditherpunk.zip
