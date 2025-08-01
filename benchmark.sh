#!/bin/ash

TMPDIR="/tmp"
TESTFILE="$TMPDIR/io_test.bin"
COUNT=100          # MB for I/O tests
LOOP_ITERS=500000 # iterations for CPU test

printf "\n=== VoCore2 Benchmark ===\n"
printf "Date: %s\n\n" "$(date)"

# 1. CPU test: integer loop
printf "1. CPU test: shell arithmetic loop (%d iterations)\n" "$LOOP_ITERS"
time sh -c "i=0; while [ \$i -lt $LOOP_ITERS ]; do i=\$((i+1)); done"

# 2. Memory throughput
printf "\n2. Memory throughput: dd if=/dev/zero of=/dev/null bs=1M count=%d\n" "$COUNT"
time dd if=/dev/zero of=/dev/null bs=1M count=$COUNT

# 3. Storage I/O
printf "\n3. Storage I/O: write %dMB then read it back\n" "$COUNT"
printf "- write test\n"
time dd if=/dev/zero of="$TESTFILE" bs=1M count=$COUNT
sync
printf "- read test\n"
time dd if="$TESTFILE" of=/dev/null bs=1M count=$COUNT
rm -f "$TESTFILE"

# 4. Network latency
printf "\n4. Network latency: ping 8.8.8.8 (5 packets)\n"
ping -c 5 8.8.8.8

printf "\n=== Done ===\n"
