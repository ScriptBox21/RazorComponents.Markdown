if ($args.Count -gt 0) {
    switch ($args[0]) {
        "npmup?" {
            Set-Location src/RazorComponents.Markdown ; ncu ; Set-Location ../..
            if (!$?) {
                exit 1
            }
        }
        "npmup" {
            Set-Location src/RazorComponents.Markdown ; ncu -u ; npm install ; Set-Location ../..
            if (!$?) {
                exit 1
            }
        }
        "restore" {
            Write-Output "Restore npm..."
            Set-Location src/RazorComponents.Markdown ; npm ci ; gulp ; Set-Location ../..
            if (!$?) {
                exit 1
            }
            dotnet restore -s https://www.myget.org/F/stardustdl/api/v3/index.json -s https://api.nuget.org/v3/index.json
            if (!$?) {
                exit 1
            }
        }
        "pack" {
            mkdir packages
            dotnet pack -c Release /p:Version=${env:build_version} -o ./packages
            if ($?) {
                exit 0
            }
            Write-Output "Retry packing..."
            dotnet pack -c Release /p:Version=${env:build_version} -o ./packages
            if ($?) {
                exit 0
            }
            Write-Output "Retry packing..."
            dotnet pack -c Release /p:Version=${env:build_version} -o ./packages
            if (!$?) {
                exit 1
            }
        }
        "format" {
            Write-Output "Format..."
            dotnet format
            if (!$?) {
                exit 1
            }
        }
        "test" {
            Write-Output "Test..."
            dotnet test /p:CollectCoverage=true
            if (!$?) {
                exit 1
            }
        }
        "benchmark" {
            Write-Output "Benchmark"
            dotnet run -c Release --project ./test/Benchmark.Base
            if (!$?) {
                exit 1
            }
        }
        Default {
            Write-Output "Unrecognized command"
            exit -1
        }
    }
}
else {
    Write-Output "Missing command"
    exit -1
}