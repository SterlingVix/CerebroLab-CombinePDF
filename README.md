# CerebroLab-CombinePDF
PDF combining automation workflow for ingestion by custom GPTs.

See for reference:
- https://apple.stackexchange.com/questions/230437/how-can-i-combine-multiple-pdfs-using-the-command-line/365073#365073
- https://github.com/coherentgraphics/cpdf-binaries

# Setting up this repo

## Script permissions
* mergepdfs.zsh needs to be made executable:
  ```bash
  chmod +x mergepdfs.zsh
  ```

## Update / Set up PDFs locally
* Download `Research References` as a .zip from Google Drive to this repo.
* Unzip `Research References` inside `pdf-in`.
** Your file structure should be:
  ```bash
  - CerebroLab-CombinePDF
  -- pdf-in
  --- Research References
  ---- ... all the sub dirs.
  ```

## Install cpdf
* Download cpdf
* Install
** For MacOS: copy `cpdf` from `OSX-ARM/cpdf` (for non-Intel) to `usr/local/bin` or another directory accessible in your $PATH.

# Merge PDFs
* from the root of the repo, execute the `mergepdfs.zsh` script:
  ```bash
  ./mergepdfs.zsh
  ```

