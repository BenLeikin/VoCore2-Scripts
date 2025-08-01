# VoCore2-Scripts
My collection of self-made scripts to benchmark my vocore2 using ash

Sample output of benchmark.sh
=== VoCore2 Benchmark ===
Date: Thu Jul 31 17:10:42 PDT 2025

1. CPU test: shell arithmetic loop (500000 iterations)
real    0m 44.80s
user    0m 42.60s
sys     0m 0.06s

2. Memory throughput: dd if=/dev/zero of=/dev/null bs=1M count=50
50+0 records in
50+0 records out
real    0m 0.26s
user    0m 0.00s
sys     0m 0.25s

3. Storage I/O: write 50MB then read it back
- write test
50+0 records in
50+0 records out
real    0m 0.78s
user    0m 0.00s
sys     0m 0.75s
- read test
50+0 records in
50+0 records out
real    0m 0.39s
user    0m 0.00s
sys     0m 0.38s

4. Network latency: ping 8.8.8.8 (5 packets)
PING 8.8.8.8 (8.8.8.8): 56 data bytes
64 bytes from 8.8.8.8: seq=0 ttl=116 time=4.672 ms
64 bytes from 8.8.8.8: seq=1 ttl=116 time=19.451 ms
64 bytes from 8.8.8.8: seq=2 ttl=116 time=4.463 ms
64 bytes from 8.8.8.8: seq=3 ttl=116 time=4.646 ms
64 bytes from 8.8.8.8: seq=4 ttl=116 time=4.478 ms

--- 8.8.8.8 ping statistics ---
5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max = 4.463/7.542/19.451 ms
