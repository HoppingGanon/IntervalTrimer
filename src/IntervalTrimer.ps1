function _IT-Get-Info ($Path) {
    return ffprobe -i $Path -show_streams -print_format json -v error | ConvertFrom-Json
}

function IT-Split ($Path, $Begin = 0, $Span = 1, $OutputPath = "$((pwd).Path)", $Type = 'mp3', $Bitrate = '192k', $Extension = 'mp3') {
    if (-not (Test-Path $Path -PathType Leaf)) {
        throw "Pathに指定したファイル('${Path}')は存在しません"
    }
    if (-not (Test-Path $OutputPath -PathType Container)) {
        throw "OutputPathに指定したフォルダ('${OutputPath}')は存在しません"
    }

    if ($Type -eq 'copy') {
        $Bitrate = ''
    } else {
        $Bitrate = "-b $Bitrate"
    }

    $info = _IT-Get-Info $Path

    $streams = $info.streams | where {$_.codec_type -eq 'audio'}

    if ($streams -eq $null) {
        if($streams.count -lt 1) {
            throw '音声ストリームがありません'
        }
    } elseif ($streams.GetType().Name -eq 'Object[]') {
        if($streams.count -lt 1) {
            throw '音声ストリームがありません'
        } else {
            $stream = $streams[0]
        }
    } else {
        $stream = $streams
    }

    $d = [Double]($stream.duration)

    if ($d -lt $Begin) {
        throw "音声が開始位置よりも短い(${d}秒)ため、変換できません"
    }

    $jobs = New-Object Collections.ArrayList
    $p = $Begin
    $i = 1
    while ($p -lt $d) {
        if ($p + $Span -ge $d) {
            $command = "ffmpeg.exe -ss $p -i `"$Path`" -c ${Type} $Bitrate -loglevel quiet -y `"$OutputPath\$($i.toString('0000')).$Extension`""
        } else {
            $command = "ffmpeg.exe -ss $p -i `"$Path`" -c ${Type} $Bitrate -t $span -loglevel quiet -y `"${OutputPath}\$($i.toString('0000')).$Extension`""
        }

        "'${OutputPath}\$($i.toString('0000')).$Extension'を出力中" | oh
        #$jobs.Add( (Start-Job { Invoke-Expression $command }) ) | Out-Null
        Invoke-Expression $command

        $p += $Span
        $i++
    }
    
    #'全ての処理の終了を待っています' | oh
    #$jobs | %{ Wait-Job $_ } | Out-Null

    '処理が完了しました' | oh
}
