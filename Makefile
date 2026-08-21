FISH_FILES := $(shell find . -name "*.fish" -not -path "./.git/*")

diff:
	chezmoi diff

apply:
	chezmoi -v apply

status:
	chezmoi status

lint:
	@for f in $(FISH_FILES); do fish -n $$f || exit 1; done
	fish_indent --check $(FISH_FILES)

fmt:
	fish_indent -w $(FISH_FILES)
