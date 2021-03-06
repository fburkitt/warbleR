#' Convert .mp3 files to .wav
#' 
#' \code{mp32wav} converts several .mp3 files in working directory to .wav format
#' @usage mp32wav(samp.rate = 44.1, parallel = 1, from = NULL, to = NULL, 
#' normalize = NULL, pb = TRUE)  
#' @param samp.rate Sampling rate at which the .wav files should be written. The maximum permitted is 44.1 kHz (default). Units should be kHz.
#' @param parallel Numeric. Controls whether parallel computing is applied.
#'  It specifies the number of cores to be used. Default is 1 (i.e. no parallel computing).
#' @param from Character string containing the directory path where the .mp3 files are located. 
#' If \code{NULL} (default) then the current working directory is used.
#' @param to Character string containing the directory path where the .wav files will be saved. 
#' If \code{NULL} (default) then the current working directory is used.
#' @param normalize Character string containing the units to be used for amplitude normalization. Check 
#' (\code{\link[tuneR]{normalize}}) for details. If NULL (default) no normalization is carried out.
#' @param pb Logical argument to control progress bar. Default is \code{TRUE}.
#' @return .wav files saved in the working directory with same name as original mp3 files.
#' @export
#' @name mp32wav
#' @examples
#' \dontrun{
#' # First set temporary folder
#' # setwd(tempdir())
#'  
#' #Then download mp3 files from xeno-canto
#' querxc(qword = "Phaethornis aethopygus", download = TRUE)
#' 
#' # Convert all files to .wav format
#' mp32wav()
#' 
#' #check this folder!!
#' getwd()
#' }
#' @details convert all .mp3 files in working directory to .wav format. Function used internally to read .mp3 files (\code{\link[tuneR]{readMP3}}) sometimes crashes.
#' @author Marcelo Araya-Salas (\email{araya-salas@@cornell.edu}) and Grace Smith Vidaurre
#last modification on mar-13-2018 (MAS)

mp32wav <- function(samp.rate = 44.1, parallel = 1, from = NULL, to = NULL, normalize = NULL, 
                    pb = TRUE) {
  
  # reset working directory 
  wd <- getwd()
  on.exit(setwd(wd))
  
  # set pb options 
  on.exit(pbapply::pboptions(type = .Options$pboptions$type), add = TRUE)
  
  if(!is.null(from))
  {if(!file.exists(from)) stop("'path' provided does not exist")} else
    from <- wd #set working directory

  setwd(from)
  
  if(!is.null(to))
  {if(!file.exists(to)) stop("'path' provided does not exist")} else
    to <- wd #set working directory
  
  #normalize
  if(!is.null(normalize))
  {if(length(normalize) >1) stop("'normalize' should have a single value")
    if(!normalize %in% c("1", "8", "16", "24", "32", "64", "0")) stop("'normalize' value not allowed (check the documentation from the normalize function in the tuneR package")
    }
  
  #fix sample rate
  if(samp.rate > 44.1) samp.rate <- 44.1
  
  #if parallel is not numeric
  if(!is.numeric(parallel)) stop("'parallel' must be a numeric vector of length 1") 
  if(any(!(parallel %% 1 == 0),parallel < 1)) stop("'parallel' should be a positive integer")
  
  #if parallel and pb in windows
  if(parallel > 1 &  pb & Sys.info()[1] == "Windows") {
    cat("parallel with progress bar is currently not available for windows OS")
    cat("running parallel without progress bar")
    pb <- FALSE
  } 
          
  files <- list.files(path=getwd(), pattern = ".mp3$", ignore.case = TRUE) #list .mp3 files in working directory
  if(length(files) == 0) stop("no 'mp3' files in working directory")
  
  #exclude the ones that already have a .wav version
  wavs <- list.files(pattern = "\\.wav$", ignore.case = TRUE)
  files <- files[!substr(files, 0, nchar(files) - 4) %in% substr(wavs, 0, nchar(wavs) - 4)]
  if(length(files) == 0) stop("all 'mp3' files have been converted")
  
 # function to convert single mp3  
 mp3_conv_FUN <- function(x, normalize) {
   
   wv <- tuneR::readMP3(filename =  x)
   
   if (wv@samp.rate != samp.rate * 1000)
   wv <- tuneR::downsample(object = wv, samp.rate = samp.rate * 1000)
   
   if (!is.null(normalize))
   wv <- tuneR::normalize(object = wv, unit = normalize)
   
   tuneR::writeWave(extensible = FALSE, object = wv, filename = file.path(from, paste0(substr(x, 0, nchar(x) - 4), ".wav")))
   }

 # set pb options 
 pbapply::pboptions(type = ifelse(pb, "timer", "none"))
 
 # set clusters for windows OS
 if (Sys.info()[1] == "Windows" & parallel > 1)
   cl <- parallel::makePSOCKcluster(getOption("cl.cores", parallel)) else cl <- parallel
 
 # run loop apply function
 out <- pbapply::pblapply(X = files, cl = cl, FUN = function(i) 
 { 
   suppressWarnings(mp3_conv_FUN(x = i, normalize))
 })  
}
