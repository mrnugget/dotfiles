function serve
    set port $argv[1]
    if test -z "$port"
        set port 8000
    end
    set ip (ipconfig getifaddr en0)
    echo "Serving on $ip:$port ..."
    python -m SimpleHTTPServer $port
end
