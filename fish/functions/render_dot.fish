function render_dot
    set out "$argv[1].png"
    dot "$argv[1]" \
        -Tpng \
        -Nfontname='JetBrains Mono' \
        -Nfontsize=10 \
        -Nfontcolor='#fbf1c7' \
        -Ncolor='#fbf1c7' \
        -Efontname='JetBrains Mono' \
        -Efontcolor='#fbf1c7' \
        -Efontsize=10 \
        -Ecolor='#fbf1c7' \
        -Gbgcolor='#1d2021' > $out
    and kitty +kitten icat --align=left $out
end
