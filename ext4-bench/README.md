Disk speed benchmarks of 1200M Disksize with 400M Memlimit with various EXT4 options

`sudo -i` drop to root
`nano disk-bench`
```
rm /var/log/test
sync; echo 3 > /proc/sys/vm/drop_caches
echo "dd bs=1M count=1024 if=/dev/zero of=/var/log/test conv=fdatasync"
dd bs=1M count=1024 if=/dev/zero of=/var/log/test conv=fdatasync
rm test
sync; echo 3 > /proc/sys/vm/drop_caches
echo "dd bs=1M count=1024 if=/dev/zero of=test conv=fdatasync"
dd bs=1M count=1024 if=/dev/zero of=test conv=fdatasync
sync; echo 3 > /proc/sys/vm/drop_caches
echo "dd if=/var/log/test of=/dev/null bs=1M count=1024 status=progress"
dd if=/var/log/test of=/dev/null bs=1M count=1024 status=progress
sync; echo 3 > /proc/sys/vm/drop_caches
echo "dd if=test of=/dev/null bs=1M count=1024 status=progress"
dd if=test of=/dev/null bs=1M count=1024 status=progress
```
`chmod a+x disk-bench`

1st sort of standard options for EXT4
```
MKFS_OPTS=""
MNT_OPTS="-o defaults,noatime"
root@raspberrypi:/home/pi# ./disk-bench
dd bs=1M count=1024 if=/dev/zero of=/var/log/test conv=fdatasync
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 5.25656 s, 204 MB/s
dd bs=1M count=1024 if=/dev/zero of=test conv=fdatasync
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 117.447 s, 9.1 MB/s
dd if=/var/log/test of=/dev/null bs=1M count=1024 status=progress
853540864 bytes (854 MB, 814 MiB) copied, 2.0019 s, 426 MB/s
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 2.52847 s, 425 MB/s
dd if=test of=/dev/null bs=1M count=1024 status=progress
1062207488 bytes (1.1 GB, 1013 MiB) copied, 46.0249 s, 23.1 MB/s
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 46.5209 s, 23.1 MB/s
```
