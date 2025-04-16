#!/bin/bash

# Remove all the previous output files (if any)
rm -f *.txt

n=$1
s=$2

if [ -f hash_app.py ]; then
   echo "It is a Python code"
   cmd='python3 hash_app.py'
   $cmd $n $s < inputs1.lst
elif [ -f *.c ]; then
   echo "It is C code"
   gcc -o hash_app hash_app.c 
   cmd='./hash_app'
   $cmd $n $s < inputs1.lst
elif [ -f *.cpp ]; then
   echo "It is a C++ code"
   g++ --std=c++17 -o hash_app hash_app.cpp
   cmd='./hash_app' 
   $cmd $n $s < inputs1.lst
elif [ -f *.java ]; then
   echo "It is a Java code"
   javac hash_app.java
   cmd='java hash_app'
   $cmd $n $s < inputs1.lst
else
   echo "Unknown code"
fi

# Check for the number of non-empty text files
fcnt=$(ls -l *.txt| awk '{if ($5 != 0) print $9}'| wc -l)

if [[ "$s" -eq 0 && "$fcnt" -eq "$n" ]]; then
    echo "---- PASSED: Minimum file count."
elif [[ "$s" -gt 0 && "$fcnt" -ge "$n" ]]; then
    echo "---- PASSED: Minimum file count."
else
    echo "---- NOT PASSED: Minimum file count."
fi

# Check for the overflows
if [[ "$s" -gt 0 ]]; then
   # Enable nullglob so that glob patterns return empty if no files match
   shopt -s nullglob

   for ((x=1; x<=n; x++)); do
       # Check if x.txt exists
       if [[ ! -f "$x.txt" ]]; then
           echo "Bucket number $x does not exist"
           continue
       fi

       # Read the comma-delimited words from x.txt
       words=$(cat "$x.txt")

       # Flag to track if all words are found in the relevant overflow files
       all_found=true

       # Loop through each word in the comma-delimited list
       IFS=',' read -r -a word_array <<< "$words"
       for word in "${word_array[@]}"; do
           # Trim spaces from the word (if any)
           word=$(echo "$word" | xargs)

           # Check if any file matches the pattern for overflow-$x-*.txt or overflow_$x_*.txt
           overflow_files=(*$x-*.txt *$x_*.txt)

           if [[ ${#overflow_files[@]} -gt 0 ]]; then
               # If matching files are found, search for the word in them
               if ! grep -q "$word" "${overflow_files[@]}"; then
                   echo "Word '$word' from bucket $x.txt not found in $x-*.txt or $x_*.txt"
                   all_found=false
               fi
           else
               echo "No matching overflow files for bucket $x"
               all_found=false
           fi
       done

       if [[ "$all_found" == true ]]; then
           echo "---- PASSED: All words in bucket $x.txt are contained in the overflow files."
       fi
   done

   # Check for the file size
   all_small=true

    for file in *.txt; do
        # Check if any .txt files exist
        [ -e "$file" ] || continue

        size=$(stat -f%z "$file")  # macOS-compatible (BSD stat)
        
        if [ "$size" -gt "$s" ]; then
            echo "File '$file' is $size bytes, which is not less than $s."
            all_small=false
        fi
    done

    if $all_small; then
        echo "---- PASSED: All txt files are smaller than $s bytes."
    else
        echo "---- NOT PASSED: Some txt files are not smaller than $s bytes."
    fi

    # Remove all .txt files safely
    rm -f *.txt

    echo $cmd
    # Run the command
    $cmd 5 5 <<< "longerthanfivechars"

    # Check if any .txt file was created
    if ls *.txt 1> /dev/null 2>&1; then
        echo "---- PASSED: Rejects longer scripts"
    else
        echo "---- NOT PASSED: Accepting longer scripts"
    fi
fi
