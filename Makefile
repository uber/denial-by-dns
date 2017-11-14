CONTAINERS = $(subst /Dockerfile.dnsgames,,$(wildcard */Dockerfile.dnsgames))
REPORTS = $(sort $(patsubst %,.gen/reports/%,$(CONTAINERS)))

.PHONY: all
# Do not remove intermediate files; we have logic to handle it anyway.
.SECONDARY:

all: scripts/generate_reports $(REPORTS)
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
	docker run -i --rm golang:1.9.2 \
		sh -c "cat > httpserver.go; CGO_ENABLED=0 go build -a -installsuffix cgo; cat go" < $< > $@
	chmod a+x $@
