CONTAINERS = $(subst /Dockerfile.dnsgames,,$(wildcard */Dockerfile.dnsgames))
REPORTS = $(sort $(patsubst %,.gen/reports/%,$(CONTAINERS)))

.PHONY: all
# Do not remove intermediate files; we have logic to handle it anyway.
.SECONDARY:

all: $(REPORTS) scripts/generate_reports
	scripts/generate_reports $(REPORTS)

.gen/reports/%: .gen/containers/% scripts/do_test
	mkdir -p .gen/reports
	rm -f $@
	scripts/do_test $*

.gen/containers/%: %/* %/Dockerfile.dnsgames .gen/httpserver scripts/dnsgames_init
	mkdir -p .gen/containers
	docker build -f $< -t dnsgames-$* .
	touch $@

.gen/httpserver: scripts/httpserver.go
	mkdir -p .gen
	docker run -i --rm golang:1.8 \
		sh -c "cat > httpserver.go; CGO_ENABLED=0 go build -a -installsuffix cgo; cat go" < $< > $@
	chmod a+x $@
