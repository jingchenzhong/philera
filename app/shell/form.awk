BEGIN{ FS=":"; n=1
    while (getline < "form.letter" > 0)
        form[n++] = $0 # store lines from form.letter in an array
    "date" | getline d; split (d, today, " ")
    # output of date is Fri Mar 2 14:35:50  CST 2011
    thisday=today[2]". "today[3]", "today[6]
}
{ for (i = 1; i < n; i ++) {
    temp=form[i]
    for (j = 1; j <= NF; j ++) {
        gsub ("@date", thisday, temp)
        gsub ("#" j, $j, temp)
    }
    print temp
}
}
