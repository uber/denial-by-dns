CONTAINERS = $(subst /Dockerfile.dnsgames,,$(wildcard */Dockerfile.dnsgames))
REPORTS = $(sort $(patsubst %,.gen/reports/%,$(CONTAINERS)))
SCRIPTS = $(shell awk '/\#!\/bin\/bash/ && FNR == 1 {print FILENAME}' scripts/*)

GO_CONTAINER = golang:1.12.4

.PHONY: all lint
# Do not remove intermediate files; we have logic to handle changes otherwise
.SECONDARY:

# depend on .gen/report.md instead of README.md to cause new `make` always rebuild
all: .gen/report.md

.gen/report.md: scripts/generate_reports $(REPORTS)
	$< $(REPORTS)

.gen/reports/%: scripts/do_test .gen/containers/%
	mkdir -p .gen/reports
	rm -f $@
	$< $*

.gen/containers/%: %/* %/Dockerfile.dnsgames .gen/httpserver scripts/dnsgames_init
	mkdir -p .gen/containers
	docker build -f $< -t dnsgames-$* .
	touch $@

.gen/httpserver: scripts/httpserver.go
	mkdir -p .gen
	docker run -i --rm $(GO_CONTAINER) \
		sh -c "cat > httpserver.go; CGO_ENABLED=0 go build -a -installsuffix cgo; cat go" < $< > $@
	chmod a+x $@

lint:
	scripts/lint
	shellcheck $(SCRIPTS)
