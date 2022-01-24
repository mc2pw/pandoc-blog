POSTS=$(shell find posts/*)
# OUT contains all names of static HTML targets corresponding to markdown files
# in the posts directory.
OUT=$(patsubst posts/%.md, p/%.html, $(POSTS))
MATHJAX_URL="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"

all: $(OUT) index.html

p/%.html: posts/%.md
	pandoc -f markdown+fenced_divs -s $< -o $@ --template templates/post.html --css="../styles/pandoc.css" --mathjax=$(MATHJAX_URL)

index.html: $(OUT) make_index.py
	python3 make_index.py
	pandoc -s index.md -o index.html --template templates/index.html  --css="./styles/pandoc.css" --css="./styles/index.css" --metadata-file="./index.yaml"
	rm index.md

# Shortcuts

open: all
	open index.html

# Get an ISO 8601 date.
date:
	date -u +"%Y-%m-%dT%H:%M:%SZ"

clean:
	rm -f p/*.html
	rm -f index.html

hook:
	ln -s -f ../../.hooks/pre-commit ./.git/hooks/pre-commit

.PHONY: install
install:
	pip install -r requirements.txt
