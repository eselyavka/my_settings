# Useful Commands

Personal command notes organized by topic.

## System Overview

### Full system activity

```bash
dstat -c -d -g -i -l -m -n -Ntotal -p -r -s -y -t
```

### Process tree

```bash
ps -e -o pid,args --forest
```

### Threads for a specific process

```bash
ps -C firefox-bin -L -o pid,tid,pcpu,state
top -H -p <pid>
```

## Memory and CPU

### Largest memory consumers

```bash
ps -eo size,pid,user,command | awk '{ hr=$1/1024 ; printf("%13i Mb ",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }' | sort -rn | head
ps -L --user $(whoami) -o pid,ppid,ruser,vsz,rss,state,priority,nice,time,%cpu,lwp,psr,cmd
ps -e -orss=,args= | sort -b -k1,1n | pr -TW$COLUMNS
```

### Largest CPU consumers

```bash
ps aux | sort -rnk 3,3 | head -5
ps -e -o pcpu,cpu,nice,state,cputime,args --sort pcpu | sed '/^ 0.0 /d'
```

### Faults and blocked tasks

```bash
ps -eo min_flt,maj_flt,cmd | sort -rnk1 | head
ps -eo stat,pid,user,command | awk '{if ($1 == "D") print $0}'
```

## Disk and Packages

### Disk usage

```bash
du -sch /.[!.]* /*
du --threshold=1G -ch /.[!.]* /*
```

### Old Ubuntu kernels

```bash
dpkg -l | tail -n +6 | grep -E 'linux-image-[0-9]+' | grep -Fv $(uname -r)
```

## Network

### SOCKS proxy for Chrome

```bash
ssh -D 1080 -f -C -q -N user@example.com
google-chrome --proxy-server="socks5://localhost:1080" --host-resolver-rules="MAP * 0.0.0.0 , EXCLUDE localhost"
```

## Git

### Show objects and file versions

```bash
git show <hash>
git show SomeOtherBranch:<filename>
```

### Bisect

```bash
git bisect start
git bisect bad HEAD
git bisect good <commit>
git bisect reset
```

### History and blame-adjacent searches

```bash
git log --patch <filename>
git log --since=two.weeks.ago --reverse -- <filename>
git log --author=<name>
git log --oneline --graph --all --abbrev-commit
git log --after="April 1, 2016" --before="April 30, 2016"
git log -L 1,1:<filename>
git log -L:bar:<filename>
git shortlog -s -n
```

### Search tracked content

```bash
git ls-files <pattern>
git grep -i --heading --line-number <pattern>
```
