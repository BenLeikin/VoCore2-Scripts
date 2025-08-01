#!/bin/ash

TMPDIR="/tmp"
TESTFILE="$TMPDIR/io_test.bin"
SDCARD_MOUNT="/mnt/mmcblk0p1"

# sizes in MB
COUNT=100            # memory & tmp-fs I/O
SDCARD_COUNT=1000     # SD-card I/O

# loop counts
LOOP_INT=5000000     # integer CPU iterations
LOOP_FLOAT=1000000   # floating-point CPU iterations
PROC_ITERS=1000      # subshell spawn count

# network targets
PING_TARGET="8.8.8.8"
DNS_HOST="openwrt.org"
DOWNLOAD_URL="http://speedtest.tele2.net/1MB.zip"

printf "\n=== VoCore2 Benchmark ===\n"
printf "Date: %s\n\n" "$(date)"

# 1. CPU integer loop
printf "1. CPU integer loop (%d iterations)\n" "$LOOP_INT"
time sh -c "i=0; while [ \$i -lt $LOOP_INT ]; do i=\$((i+1)); done"

# 2. CPU float loop
printf "\n2. CPU float loop (%d iterations)\n" "$LOOP_FLOAT"
time sh -c "awk 'BEGIN { for(i=0;i<${LOOP_FLOAT};i++) x=i*3.14159 }'"

# 3. Process-spawn latency
printf "\n3. Process spawn (%d subshells)\n" "$PROC_ITERS"
time sh -c "i=0; while [ \$i -lt $PROC_ITERS ]; do sh -c ':'; i=\$((i+1)); done"

# 4. Memory throughput
printf "\n4. Memory throughput (zero→null, %dMB)\n" "$COUNT"
time dd if=/dev/zero of=/dev/null bs=1M count=$COUNT

# 5. Random I/O
printf "\n5. Random I/O (urandom→null, %dMB)\n" "$COUNT"
time dd if=/dev/urandom of=/dev/null bs=1M count=$COUNT

# 6. tmp-fs I/O
printf "\n6. tmp-fs I/O (%dMB)\n" "$COUNT"
printf "  write: "
time dd if=/dev/zero of="$TESTFILE" bs=1M count=$COUNT >/dev/null 2>&1
sync
printf "  read:  "
time dd if="$TESTFILE" of=/dev/null bs=1M count=$COUNT >/dev/null 2>&1
rm -f "$TESTFILE"

# 7. SD-card I/O
printf "\n7. SD-card I/O on %s (%dMB)\n" "$SDCARD_MOUNT" "$SDCARD_COUNT"
printf "  write: "
time dd if=/dev/zero of="$SDCARD_MOUNT/io_test_sd.bin" bs=1M count=$SDCARD_COUNT >/dev/null 2>&1
sync
printf "  read:  "
time dd if="$SDCARD_MOUNT/io_test_sd.bin" of=/dev/null bs=1M count=$SDCARD_COUNT >/dev/null 2>&1
rm -f "$SDCARD_MOUNT/io_test_sd.bin"

# 8. File-metadata throughput
printf "\n8. File-metadata: count files under %s\n" "$SDCARD_MOUNT"
time find "$SDCARD_MOUNT" -type f | wc -l

# 9. Compression test
if command -v gzip >/dev/null 2>&1; then
  printf "\n9. Compression: gzip on %dMB SD test file\n" "$SDCARD_COUNT"
  dd if=/dev/zero of="$SDCARD_MOUNT/io_test_sd.bin" bs=1M count=$SDCARD_COUNT >/dev/null 2>&1
  time gzip -c "$SDCARD_MOUNT/io_test_sd.bin" >/dev/null 2>&1
  rm -f "$SDCARD_MOUNT/io_test_sd.bin"
else
  printf "\n9. Compression: gzip not installed, skipping\n"
fi

# 10. Network latency
printf "\n10. Network latency: ping %s (5 packets)\n" "$PING_TARGET"
ping -c 5 "$PING_TARGET"

# 11. DNS lookup
printf "\n11. DNS lookup: resolve %s\n" "$DNS_HOST"
time sh -c "ping -c1 -W1 $DNS_HOST >/dev/null"

# 12. HTTP download
if command -v wget >/dev/null 2>&1; then
  printf "\n12. HTTP download: %s\n" "$DOWNLOAD_URL"
  time wget -qO /dev/null "$DOWNLOAD_URL"
else
  printf "\n12. HTTP download: wget not installed, skipping\n"
fi

printf "\n=== Done ===\n"
