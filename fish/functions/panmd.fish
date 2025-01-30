function panmd
    set -l tempfile (mktemp -t pandoc_out.XXXXXX)".html"
    if test -n "$argv[1]"
        # If an argument is provided, use it as input file
        pandoc -s -f markdown -t html "$argv[1]" -o $tempfile
    else
        # Otherwise read from stdin
        pandoc -s -f markdown -t html -o $tempfile
    end
    and open $tempfile
end
