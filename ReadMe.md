# download-ts-files

## Description
* download.command: download one ep. of one course at once time
* whole.command: download one course at once time
* all.command: download multiple courses at once time

## Execution
### install brew
```
> ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### install wget, ffmpeg
```
> brew install wget
> brew install ffmpeg
> brew upgrade
```

### chmod
```
> chmod 755 *.command
```

### execution
* download.command
```
> mkdir
> cd
> ./download.command "playlist.m3u8 url" "save file name"
```

* whole.command
```
> mkdir
> cd
> sudo ./whole.command "no. of course" "save file name" "num. of ep." "auto shutdown or not"
```

* all.command
```
> sudo ./all.command
```