test:
	cd t; prove .

coverage:
	cover -test

clean:
	rm -f *~
	rm -f t/*~
	rm -fr cover_db/
