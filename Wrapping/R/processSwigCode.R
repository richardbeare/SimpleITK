# Modify SimpleITK.R as follows:
#
# remove the various delete generic methods. These are not
# used and are created incorrectly by swig (calling something
# that doesn't exist).
# Ultimately I will fix swig, but the turnaround is too long.
#
# Generate some documentation files for the various $ methods.
# The CRAN checks complain about missing documentation otherwise.
#
# Both of these steps can be accomplished largely with grep-style
# approaches.
#

writeAlias <- function(m, outfile) {
  con <- file(outfile, open='w')
  writeLines(c("\\docType{data}",
               "\\name{hidden_methods}",
               "\\alias{hidden_methods}"), con)

  p <- gsub("^setMethod\\(\\'\\$\\', \\'(.+)\\', function.+", "\\1", m)
  p <- paste0("\\alias{$,", p, "-method}")
  writeLines(p, con)
  writeLines(c("\\title{Internal page for hidden methods}",
               "\\description{ For S4 methods that require docmentation, but clutter index }",
               "\\keyword{internal}"), con)

  close(con)
}

processSwig <- function(swigsrc, swigdest, docdest) {
  code <- readLines(swigsrc)
  code <- grep("^setMethod\\('delete',", code, value=TRUE, invert=TRUE)
  writeLines(code, swigdest)
  dollarmethods <- grep("^setMethod\\('\\$',", code, value=TRUE)
  writeAlias(dollarmethods, docdest)
}
args <- commandArgs( TRUE )
src <- args[[1]]
dest <- args[[2]]
destdoc <- args[[3]]
processSwig(src, dest, destdoc)
q(save="no")
