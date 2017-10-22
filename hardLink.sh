#!/bin/bash

fdupes -r . | tee /tmp/fdupes.out | perl -ne '
  chomp;
  if (/^./) { 
    push @f, $_; 
  } else {
    $k = shift @f;
    for (@f) {
      chmod 0666, $_; unlink $_; link $k, $_;
    }
    @f = ();
  }
'
