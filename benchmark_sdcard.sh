#!/bin/ash

TMPDIR="/tmp"
TESTFILE="$TMPDIR/io_test.bin"

# sizes in MB
COUNT=10            # memory & tmp-fs I/O tests
SDCARD_MOUNT="/mnt/mmcblk0p1"
SDCARD_COUNT=10     # SD-card I/O test

LOOP_ITERS=500000   # CPU test iterations

printf "\n=== VoCore2 Benchmark ===\n"
printf "Date: %s\n\n" "$(date)"

# 1. CPU test: integer loop
printf "1. CPU test: shell arithmetic loop (%d iterations)\n" "$LOOP_ITERS"
time sh -c "i=0; while [ \$i -lt $LOOP_ITERS ]; do i=\$((i+1)); done"

# 2. Memory throughput
printf "\n2. Memory throughput: dd if=/dev/zero of=/dev/null bs=1M count=%d\n" "$COUNT"
time dd if=/dev/zero of=/dev/null bs=1M count=$COUNT

# 3. tmp-fs I/O
printf "\n3. tmp-fs I/O: write %dMB then read it back\n" "$COUNT"
printf "- write test\n"
time dd if=/dev/zero of="$TESTFILE" bs=1M count=$COUNT
sync
printf "- read test\n"
time dd if="$TESTFILE" of=/dev/null bs=1M count=$COUNT
rm -f "$TESTFILE"

# 4. SD-card I/O
printf "\n4. SD-card I/O on %s: write %dMB then read it back\n" "$SDCARD_MOUNT" "$SDCARD_COUNT"
printf "- write test\n"
time dd if=/dev/zero of="$SDCARD_MOUNT/io_test_sd.bin" bs=1M count=$SDCARD_COUNT
sync
printf "- read test\n"
time dd if="$SDCARD_MOUNT/io_test_sd.bin" of=/dev/null bs=1M count=$SDCARD_COUNT
rm -f "$SDCARD_MOUNT/io_test_sd.bin"

# 5. Network latency
printf "\n5. Network latency: ping 8.8.8.8 (5 packets)\n"
ping -c 5 8.8.8.8

printf "\n=== Done ===\n"
