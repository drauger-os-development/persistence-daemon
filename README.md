# persistence-daemon
Simple Persistence Daemon for Live USB/DVD/etc systems

# To use
Persistence Daemon has only 2 requirements:
 * the persistent data partition must be labeled or named EITHER: `persist` OR `persistent`, case INSENSITIVE
 * As of now, only the following file systems are allowed:
   * EXT2/3/4
   * BTRFS
   * JFS
   * XFS
   * F2FS
   
Some limitations of Persistence Daemon:
 * The following filesystems CANNOT be supported due to lack of support for Linux filesystem permissions:
   * FAT32/16/12
   * exFAT/vFAT
   * NTFS
 * The following would require either a DKMS module or native kernel support in order to implement:
   * ZFS
