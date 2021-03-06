# Dockerized AFL for x86_64 Binaries using QEMU

## 1. Build docker
   ```
   $ git clone https://github.com/cpuu/afl-x86_64.git
   $ cd afl-x86_64
   $ docker build -t afl-x86_64 .
   ```

## 2. Run afl with the script:
   ```
   ./run.sh <timeout> <io dir name> <seed dir name> <binary path> <args ...>
   ```

### Example 1 - vuln

```
$ rm -rf ./io
$ ./run.sh 15 io tests/vuln/seeds tests/vuln/vuln @@
```

### Example 2 - aql
```
$ rm -rf ./io
$ ./run.sh 60 io tests/aql/seeds/ tests/aql/test_aql_plain.exe @@
```

## 3. Manual command:

1) Run Docker container and go inside
```
$ docker run --entrypoint="bash" -v /home/ubuntu/afl-x86_64/tests:/home/afl/tests -it afl-x86_64
root@05d86b4444e8:/home/afl#
```
2) Fuzz with qemu-x86_64
```
root@05d86b4444e8:/home/afl# mkdir output/
root@05d86b4444e8:/home/afl# afl-fuzz -m none -Q -i ./tests/aql/seeds/ -o ./output/ ./tests/aql/test_aql_plain.exe @@
```
3) Check crash inputs
```
# ./teststs/aql/test_aql_plain.exe ./output/crashes/id\:000000\,sig\:06\,src\:000000\,op\:havoc\,rep\:2 
-----------------------------
helllllSllllllllllo!

-------------------------
size of input data = 21
start parsing!!

JB patched : aql-lexer.c:243 next_token() : stack buffer overflow (next_token) : lexer->value >= DB_MAX_ELEMENT_SIZE 

*** stack smashing detected ***: <unknown> terminated
qemu: uncaught target signal 6 (Aborted) - core dumped
Aborted
```
