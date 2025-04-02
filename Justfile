assets := 'assets'
fonts := assets / 'fonts'
images := assets / 'images'
redacted := assets / 'cv.pdf'

source := 'src'
output := 'out'

main := source / 'main.typ'
pdf := output / 'cv.pdf'

export TYPST_ROOT := justfile_directory()
export TYPST_FONT_PATHS := fonts

# list recipes
[private]
default:
	@just --list --unsorted

# initialize the repo for editing
init:
	cp {{ assets / 'redacted.toml' }} {{ assets / 'sensitive.toml' }}

# generate document with sensitive data
build: prep
	typst compile --input 'data=sensitive' {{ main }} {{ pdf }}

# watch document with sensitive data
watch: prep
	typst watch --input 'data=sensitive' {{ main }} {{ pdf }}

# update the example document with non-sensitive data
update:
	typst compile --input 'data=redacted' {{ main }} {{ pdf }}
	cp {{ pdf }} {{ redacted }}

# clean all output directories
clean:
	rm --recursive --force {{ output }}

# run the ci checks locally
ci: prep
	typst compile --input 'data=redacted' {{ main }} {{ pdf }}

[private]
prep:
	rm --recursive --force {{ output }}
	mkdir {{ output }}
