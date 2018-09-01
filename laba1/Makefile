liblab1.so: main.o
	gcc -shared -o liblab1.so main.o
	sudo cp liblab1.so /usr/lib/postgresql/9.5/lib/liblab1.so

main.o: main.c
	gcc -I/usr/include/postgresql/9.5/server -fPIC -c main.c
		
clean:
	rm -f *.o *.so
