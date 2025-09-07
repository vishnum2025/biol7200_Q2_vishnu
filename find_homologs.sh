#!/usr/bin/env bash

query=$1
subject=$2
out=$3

: > "$out"

tblastn \
  -query "$query" \
  -subject "$subject" \
  -outfmt '6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen' \
| awk -v out="$out" '
  {
    pident = $3;  
    alen  = $4;   
    qlen  = $13;  
    if (pident > 30 && (alen/qlen) > 0.9) {
      print >> out
      n++
    }
  }
  END { close(out); print n+0 }
'
