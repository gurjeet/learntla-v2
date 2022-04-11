﻿Remove-FileSystemWatcher -SourceIdentifier "learntla"
New-FileSystemWatcher -SourceIdentifier "learntla" -Path $PSScriptRoot -IncludeSubdirectories -Filter *.rst

Remove-FileSystemWatcher -SourceIdentifier "cleanup"
New-FileSystemWatcher -SourceIdentifier "cleanup" -Path $PSScriptRoot -IncludeSubdirectories -Filter *.old
Register-EngineEvent -SourceIdentifier "cleanup" -Action {rm $event.Messagedata.FullPath}

$docs_path = "$PSScriptRoot\docs"

while($true) {
    wait-event "learntla"
    remove-event "learntla"
    & "$PSScriptRoot\venv-sphinx\Scripts\sphinx-build.exe" $docs_path "$docs_path\_build\html"
}
