# CerebroLab-CombinePDF
PDF combining automation workflow for ingestion by custom GPTs.

See for reference:
- https://apple.stackexchange.com/questions/230437/how-can-i-combine-multiple-pdfs-using-the-command-line/365073#365073
- https://github.com/coherentgraphics/cpdf-binaries

# Install
* Download cpdf
* Install
** For MacOS: copy `cpdf` from `OSX-ARM/cpdf` (for non-Intel) to `usr/local/bin`.

# Merge PDFs
* Download `Research References` from Google Drive to this repo.
* 

* mergepdfs.zsh needs to be made executable:
** `chmod +x mergepdfs.zsh`


```
# Scan current directory, cd into first folder
cd "$(find . -maxdepth 1 -type d | sed -n '2p')"
```


```
# List all files in the current directory
find "INPUT FOLDER" -maxdepth 1 -type f -exec basename {} \; | tr '\n' ' '

# Print all files in this dir wrapped in quotes.
printf '"%s" ' *.*(N)
```


```
# Merge the files into a new pdf "out.pdf".
cpdf -merge in.pdf in2.pdf -o out.pdf

# Merge files retrieved programatically from this directory.
cpdf -merge $(printf '"%s" ' *.*(N)) -o out.pdf

# Write the line to the CLI (debugging)
echo "cpdf -merge $(printf '"%s" ' *.*(N)) -o out.pdf"
```

printf '"%s" ' *.*(N)



cpdf -merge TDP-43 and Phosphorylated TDP-43 Levels in Paired Plasma and CSF Samples in Amyotrophic Lateral Sclerosis.pdf Mitigation of TDP-43 toxic phenotype by an RGNEF fragment in amyotrophic lateral sclerosis models.pdf _ PROTEIN AGGREGATES.pdf Aqp4 stop codon readthrough facilitates amyloidclearance from the brain.pdf Suvorexant acutely decreases tau phosphorylation and Aβ in the human CNS.pdf -o out.pdf