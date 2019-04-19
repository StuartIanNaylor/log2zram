# Log2Zram

Usefull for IoT / maker projects for reducing SD, Nand and Emmc block wear via log operations.
Uses Zram to minimise precious memory footprint and extremely infrequent write outs.

Can not be used for mission critical logging applications where a system crash and log loss is unaceptable.
If the extremely unlikely event of a system crash is not a major concern then L2Z can massively reduce log block wear whilst maintaining and extremely tiny memory footprint. Further resilience can be added by the use of a watchdog routine to force stop.

Uses an OverlayFS lower bind mount of /var/log to /opt/zram and upper zram to create fast startups and extremely small memory requirements.
On stop uses https://github.com/kmxz/overlayfs-tools merge tool to merge from volatile ram to persistant.
Many thanks kmxz for providing one of the only overlayfs tools available. 

Works well in conjunction with https://github.com/StuartIanNaylor/zramdrive and https://github.com/StuartIanNaylor/zram-swap-config
_____
## Menu
1. [Install](#install)
2. [Config](#config)
3. [It is working ?](#it-is-working)
4. [Uninstall](#uninstall-)

## Install
    sudo apt-get install git
    git clone https://github.com/StuartIanNaylor/log2zram
    cd log2zram
    sudo sh install.sh
    

## Customize
#### variables :
In the file `/etc/log2zram.conf` `sudo nano /etc/log2zram.conf` to edit:
```
# Size for the zram memory used, it defines the mem_limit for the zram device.
# The default is 20M and is basically enough for minimal applications.
# Because aplications can often vary in logging frequency this may have to be tweaked to suit application .
SIZE=20M

# COMP_ALG this is any compression algorithm listed in /proc/crypto
# lz4 is fastest with lightest load but deflate (zlib) and Zstandard (zstd) give far better compression ratios
# lzo is very close to lz4 and may with some binaries have better optimisation
# COMP_ALG=lz4 for speed or deflate for compression, lzo or zlib if optimisation or availabilty is a problem
COMP_ALG=lz4

# LOG_DISK_SIZE is the uncompressed disk size. Note zram uses about 0.1% of the size of the disk when not in use
# LOG_DISK_SIZE is expected compression ratio of alg chosen multiplied by log SIZE where 300% is an approx good level.
# lzo/lz4=2.1:1 compression ratio zlib=2.7:1 zstandard=2.9:1
# Really a guestimate of a bit bigger than compression ratio whilst minimising 0.1% mem usage of disk size
LOG_DISK_SIZE=60M

# mke2fs & mount drive options set for max write perf in volatile ram
# https://manpages.debian.org/jessie/e2fsprogs/mke2fs.8.en.html
# https://manpages.debian.org/stretch/mount/mount.8.en.html
MKFS_OPTS="-O ^has_journal"
MNT_OPTS="-o rw,noatime,async,nosuid,noexec,nodev,nobarrier,nodelalloc"

# Zram & mount directories defaults can be changed if wished
ZDIR=/opt/zram
HDD_LOG=/opt/zram/hdd.log
```

### It is working?
```
pi@raspberrypi:~ $ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/root        15G  1.2G   13G   9% /
devtmpfs        460M     0  460M   0% /dev
tmpfs           464M     0  464M   0% /dev/shm
tmpfs           464M  6.2M  458M   2% /run
tmpfs           5.0M  4.0K  5.0M   1% /run/lock
tmpfs           464M     0  464M   0% /sys/fs/cgroup
/dev/mmcblk0p1   44M   22M   22M  50% /boot
/dev/zram0       59M  920K   54M   2% /opt/zram/zram0
overlay0         59M  920K   54M   2% /var/log
tmpfs            93M     0   93M   0% /run/user/1000
```
```
pi@raspberrypi:~ $ zramctl
NAME       ALGORITHM DISKSIZE  DATA  COMPR TOTAL STREAMS MOUNTPOINT
/dev/zram0 lz4            60M 1004K 212.3K  424K       4 /opt/zram/zram0
```
```
pi@raspberrypi:~ $ ls /usr/local/share/log2zram/log
log2zram.log
```

| Compressor name	     | Ratio	| Compression | Decompress. |
|------------------------|----------|-------------|-------------|
|zstd 1.3.4 -1	         | 2.877	| 470 MB/s	  | 1380 MB/s   |
|zlib 1.2.11 -1	         | 2.743    | 110 MB/s    | 400 MB/s    |
|brotli 1.0.2 -0	     | 2.701	| 410 MB/s	  | 430 MB/s    |
|quicklz 1.5.0 -1	     | 2.238	| 550 MB/s	  | 710 MB/s    |
|lzo1x 2.09 -1	         | 2.108	| 650 MB/s	  | 830 MB/s    |
|lz4 1.8.1	             | 2.101    | 750 MB/s    | 3700 MB/s   |
|snappy 1.1.4	         | 2.091	| 530 MB/s	  | 1800 MB/s   |
|lzf 3.6 -1	             | 2.077	| 400 MB/s	  | 860 MB/s    |

Zstd & Zlib are great for text compression where ratios of up to 3.3 can be obtained. Generally 230% for LZO/LZ4 LOG_DISK_SIZE over the Mem_Limit of Size should be OK, with Zlib/Zstd maybe even up to 350% can be expected.
Most logrotate schedules compress after the second stored log (log.1) and the ratio between uncompressed and compressed log can have much effect. So it dependent on your logging setup with LZO/LZ4 ranging from 210-250% ZSTD/ZLIB 290-350% for the same Mem_Limit Size.
Generally these are minimum compression rates but how much whitespace and zeroes does a file contain? 

## Uninstall
```
sudo sh /usr/local/bin/log2zram/uninstall.sh
```

## Git Branches & Update
From the command line, enter `cd <path_to_local_repo>` so that you can enter commands for your repository.
Enter `git add --all` at the command line to add the files or changes to the repository
Enter `git commit -m '<commit_message>'` at the command line to commit new files/changes to the local repository. For the <commit_message> , you can enter anything that describes the changes you are committing.
Enter `git push`  at the command line to copy your files from your local repository to remote.

## Overlayfs-tools Compilation Problems
If you're having problems compiling overlayfs-tools due to a kernel and stdlib header mismatch see here:
https://github.com/systemd/systemd/commit/75720bff62a84896e9a0654afc7cf9408cf89a38
