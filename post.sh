#!/bin/bash
# Create post

# User must set title.
# Title will be header of post. Post filename will use title formatted to replace spaces with '-'
# post will be named date_title.md
title=$1

if [ -z ${title// /-} ]; then
  echo "must enter 1 argument: title";
  exit 1;
fi

#set date
date=`date +%Y-%m-%d`

#make filename
#File will be put in _posts/ directory
filename="_posts/"$date"-"${title// /-}".md"

if [ -e $filename ]; then
  echo "File $filename already exists!"
  exit 1;
else
  echo >> $filename
fi

# write header to file
echo "---
layout: post
title: \"$title\"
date: $date
---" >> $filename