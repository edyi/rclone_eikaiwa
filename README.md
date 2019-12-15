## [rclone](https://github.com/rclone/rclone)
- バックアップに使えるツール。
- 他にも[gdrive](https://github.com/gdrive-org/gdrive)というのを検討したが開発が止まっているようなので利用しなかった。（開発を再開するとは書いてある）  
さらに[borg](https://github.com/borgbackup/borg)というのも試したがこちらはクラウドへのアップロード方法がよくわからず（おそらくマウントが必要）、  
最終的に直接google driveにファイルを送れるrcloneにした。  


- ちなみにborgは簡単に暗号化ができるのがよい。  
borgは下記のようにborg_test/dataにあるものをborg_test/backup/にバックアップできた。
```
  # borg init -e repokey /usr/local/borg_test/backup/
  # borg create -v --stats /usr/local/borg_test/backup/::backuptest1 /usr/local/borg_test/data/
```

### rclone インストール
- `root@raspberrypi:~# apt-get install rclone`

### rclone バージョン確認
```
# rclone version
rclone v1.35-DEV
```

### rclone 設定
```
pi@raspberrypi:~ $ rclone config
2019/12/15 11:38:22 Config file "/home/pi/.rclone.conf" not found - using defaults
No remotes found - make a new one
n) New remote
s) Set configuration password
q) Quit config
n/s/q> n


name> gdrive-test
Type of storage to configure.
Choose a number from below, or type in your own value
 1 / Amazon Drive
   \ "amazon cloud drive"
 2 / Amazon S3 (also Dreamhost, Ceph, Minio)
   \ "s3"
 3 / Backblaze B2
   \ "b2"
 4 / Dropbox
   \ "dropbox"
 5 / Encrypt/Decrypt a remote
   \ "crypt"
 6 / Google Cloud Storage (this is not Google Drive)
   \ "google cloud storage"
 7 / Google Drive
   \ "drive"
 8 / Hubic
   \ "hubic"
 9 / Local Disk
   \ "local"
10 / Microsoft OneDrive
   \ "onedrive"
11 / Openstack Swift (Rackspace Cloud Files, Memset Memstore, OVH)
   \ "swift"
12 / Yandex Disk
   \ "yandex"
Storage> 7


Google Application Client Id - leave blank normally.
client_id>


Google Application Client Secret - leave blank normally.
client_secret>


Remote config
Use auto config?
 * Say Y if not sure
 * Say N if you are working on a remote or headless machine or Y didn't work
y) Yes
n) No
y/n> n　ローカルPCではなくラズパイなのでn


If your browser doesn't open automatically go to the following link: https://accounts.google.com/ ここのリンク先へ移動して認証コードを得る。
Log in and authorize rclone for access
Enter verification code> ここに貼り付ける
--------------------
[gdrive-test]
client_id =
client_secret =
token = {"access_token":"・・・"}
--------------------
y) Yes this is OK
e) Edit this remote
d) Delete this remote
y/e/d> y


Current remotes:

Name                 Type
====                 ====
gdrive-test          drive

e) Edit existing remote
n) New remote
d) Delete remote
s) Set configuration password
q) Quit config
e/n/d/s/q> q
```


### expiryについて
- 設定を確認するとなんとなくすぐにtokenの有効期限が切れてしまいそうだけど、自動で更新されるらしい。
```
cat /home/pi/.rclone.conf
[gdrive-test]
type = drive
client_id =
client_secret =
token = {"access_token":"xxx","token_type":"Bearer","refresh_token":"xxx",
"expiry":"2019-12-15T12:40:51.065347513+09:00"} ←これ
```
実際なにも更新などやっていないが使えている。  
参考：https://github.com/rclone/rclone/issues/2047


## 実行方法
### 直接
----
```
root@raspberrypi:~# curl -s https://raw.githubusercontent.com/edyi/rclone_eikaiwa/master/rclone_exec.sh | bash
          -1 2019-12-14 12:58:02        -1 12月
          -1 2019-11-04 23:52:45        -1 11月
          -1 2019-10-03 00:07:11        -1 9月
          -1 2019-10-03 00:04:23        -1 10月
          -1 2019-08-01 23:48:38        -1 8月
          -1 2019-07-22 23:57:21        -1 7月
          -1 2019-07-22 23:57:15        -1 6月
          -1 2019-07-22 23:57:09        -1 5月
          -1 2019-07-22 23:57:02        -1 4月
          -1 2019-05-06 11:24:14        -1 一週間まとめて
2019/12/15 00:09:42 Google drive root '01_語学学習/eikaiwa2019/12月': Waiting for checks to finish
2019/12/15 00:09:42 Google drive root '01_語学学習/eikaiwa2019/12月': Waiting for transfers to finish
2019/12/15 00:09:46
Transferred:   5.171 MBytes (616.932 kBytes/s)
Errors:                 0
Checks:                 0
Transferred:            1
Elapsed time:        8.5s
```

cron
-----
```
# Review
0 18 * * sun     root curl -s https://raw.githubusercontent.com/edyi/rclone_eikaiwa/master/rclone_exec.sh | bash >/tmp/rclone.log 2>&1
5 18 * * sun     root /home/pi/radio-eikaiwa/slack.sh

# Daily
10 7 * * mon-fri root curl -s https://raw.githubusercontent.com/edyi/rclone_eikaiwa/master/rclone_exec.sh | bash >/tmp/rclone.log 2>&1
15 7 * * mon-fri root /home/pi/radio-eikaiwa/slack.sh
```