Disk speed benchmarks of 1200M Disksize with 400M Memlimit with various EXT4 options

`sudo -i` drop to root
`nano disk-bench`
```
sync; echo 3 > /proc/sys/vm/drop_caches
echo "dd bs=1M count=1024 if=/dev/zero of=/var/log/test conv=fdatasync"
dd bs=1M count=1024 if=/dev/zero of=/var/log/test conv=fdatasync
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
root@raspberrypi:/home/pi# sync; echo 3 > /proc/sys/vm/drop_caches
root@raspberrypi:/home/pi# sudo dd bs=1M count=1024 if=/dev/zero of=/var/log/test conv=fdatasync
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 5.36067 s, 200 MB/s

root@raspberrypi:/home/pi# sync; echo 3 > /proc/sys/vm/drop_caches
root@raspberrypi:/home/pi# sudo dd bs=1M count=1024 if=/dev/zero of=test conv=fdatasync
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 121.72 s, 8.8 MB/s

sync; echo 3 > /proc/sys/vm/drop_caches 
root@raspberrypi:/home/pi# dd if=/var/log/test of=/dev/null bs=1M count=512 status=progress
412090368 bytes (412 MB, 393 MiB) copied, 1.00039 s, 412 MB/s
512+0 records in
512+0 records out
536870912 bytes (537 MB, 512 MiB) copied, 1.31076 s, 410 MB/s

sync; echo 3 > /proc/sys/vm/drop_caches 
root@raspberrypi:/home/pi# dd if=test of=/dev/null bs=1M count=1024 status=progress
1062207488 bytes (1.1 GB, 1013 MiB) copied, 46.0358 s, 23.1 MB/s
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 46.5318 s, 23.1 MB/s
```
