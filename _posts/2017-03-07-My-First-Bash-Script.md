---
layout: post
title: "My First Bash Script"
date: 2017-03-07
---

I use Jekyll for this blog. I chose it because it is very easy to use. It means I do not have to CRUD everything myself. Posts are written in an accessible, formatible markdown. I customized my Jekyll template and voila! Instant blog!

But there is a tediousness to writing a Jekyll blog post. First, formatting matters. You must format 2 things consistently or Jekyll can't understand your posts.

1. You must format the file name to be year-month-day-title-of-post.md
2. You must add a header to each of your post markdowns in the following format

```shell
  ___
  layout: layout_name
  title: "Title of post"
  date: year-month-day
  ___
```

This is VERY Tedious to do. If you write a post often, who wants to do this every time? If you don't write often, who wants to remember how?

So I wrote my first bash script.

Along the way, I had to look up a few things:

1. How to take arguments from the commandline
2. How to set variables
3. How to check if variables are set
4. How to create a file
5. How to write to a file
6. How to end the script if errors occur
7. Regex in bash
8. How to get the date

Check it out! (Note there's still a bug where a new line gets added as the first line. Working on it!)

```shell
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
echo "---" >> $filename
echo "layout: post" >> $filename
echo "title: \"$title\"" >> $filename
echo "date: $date" >> $filename
echo "---" >> $filename
```
