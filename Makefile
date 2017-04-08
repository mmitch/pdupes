DEPS	:= .deps
SOURCES	:= pdupes $(wildcard t/*.t)

test:
	cd t; prove .

coverage:
	cover -test

clean:
	rm -f $(DEPS)
	rm -f *~
	rm -f t/*~
	rm -fr cover_db/

$(DEPS): $(SOURCES)
	grep ^use $(SOURCES) | awk '{print $$2}' | sed 's/;$$//' | egrep -v '^(strict|warnings)$$' | sort | uniq > $@

showdeps: $(DEPS)
	cat $(DEPS)

installdeps: $(DEPS)
	cpanm --skip-satisfied < $(DEPS)
