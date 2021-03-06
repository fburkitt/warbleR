% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/manualoc.R
\name{manualoc}
\alias{manualoc}
\title{Interactive view of spectrograms}
\usage{
manualoc(wl = 512, flim = c(0,12), seltime = 1, tdisp = NULL, reccomm =
  FALSE, wn = "hanning", title = TRUE, selcomm = FALSE, osci = FALSE, player =
  NULL, pal = reverse.gray.colors.2, path = NULL, flist = NULL, 
  fast.spec = FALSE, ext.window = TRUE, width = 15, height = 5)
}
\arguments{
\item{wl}{A numeric vector of length 1 specifying the spectrogram window length. Default is 512.}

\item{flim}{A numeric vector of length 2 specifying the frequency limit (in kHz) of 
the spectrogram, as in the function \code{\link[seewave]{spectro}}. 
Default is c(0,12).}

\item{seltime}{A numeric vector of length 1 indicating the time interval in seconds at which 
the spectrograms are produced with higher resolution (ovlp = 70) and oscilograms (if osci = \code{TRUE}). 
 Default is 1 second.}

\item{tdisp}{A numeric vector of length 1 specifying the length in seconds of the total sound file to 
be displayed. Default is \code{NULL} which displays the full sound file.}

\item{reccomm}{Logical argument. If \code{TRUE} pops up a comment window at the end of each sound file.
The comment needs to be quoted. Default is \code{FALSE}.}

\item{wn}{A character vector of length 1 specifying the window function (by default "hanning"). See function 
\code{\link[seewave]{ftwindow}} for more options.}

\item{title}{Logical argument. If \code{TRUE} the name of the sound file will be printed as the main 
title of the spectrogram window. Default is \code{TRUE}}

\item{selcomm}{Logical argument. If \code{TRUE} pops up a comment window after each selection. The 
comment is printed as a label on the selected unit. The comment must be quoted. Default is \code{FALSE}}

\item{osci}{Logical argument. If \code{TRUE} adds a oscillogram whenever the spectrograms are produced 
with higher resolution (see seltime). Default is \code{FALSE}.}

\item{player}{Path to or name of a program capable of playing a wave file by 
invocation from the command line. If under Windows and no player is given, 
windows player will be chosen as the default. "vlc" works in Linux if vlc player is installed. 
The external program must be closed before resuming analysis. Default is \code{NULL}.}

\item{pal}{A color palette function to be used to assign colors in the 
plot, as in \code{\link[seewave]{spectro}}. Default is reverse.gray.colors.2. See Details.}

\item{path}{Character string containing the directory path where the sound files are located. 
If \code{NULL} (default) then the current working directory is used.}

\item{flist}{character vector or factor indicating the subset of files that will be analyzed. Ignored
if X is provided.}

\item{fast.spec}{Logical. If \code{TRUE} then image function is used internally to create spectrograms, which substantially 
increases performance (much faster), although some options become unavailable, as collevels, and sc (amplitude scale).
This option is indicated for signals with high background noise levels. Palette colors \code{\link[monitoR]{gray.1}}, \code{\link[monitoR]{gray.2}}, 
\code{\link[monitoR]{gray.3}}, \code{\link[monitoR]{topo.1}} and \code{\link[monitoR]{rainbow.1}} (which should be imported from the package monitoR) seem
to work better with 'fast' spectograms. Palette colors \code{\link[monitoR]{gray.1}}, \code{\link[monitoR]{gray.2}}, 
\code{\link[monitoR]{gray.3}} offer 
decreasing darkness levels.}

\item{ext.window}{Logical. If \code{TRUE} then and external graphic window is used. Default 
dimensions can be set using the 'width' and 'height' arguments. Default is \code{TRUE}.}

\item{width}{Numeric of length 1 controling the width of the external graphic window. Ignored
if \code{ext.window = FALSE}. Default is 15.}

\item{height}{Numeric of length 1 controling the height of the external graphic window.
Ignored if \code{ext.window = FALSE}. Default is 5.}
}
\value{
.csv file saved in the working directory with start and end time of 
  selections.
}
\description{
\code{manualoc} produces an interactive spectrographic view in which the start 
and end times of acoustic signals can be measured.
}
\details{
Users can zoom-in a specific sound file segment by clicking at the 
  start and end (left side and right side) of the segment. To select the
  start and end of a vocalization unit the users need to click at the end and
  then at the start (right side and left side) of the unit. In addition, 6 
  "buttons" are provided at the upper right side of the spectrogram that
  allow to display a full view of the spectrogram ("Full view"), go back to
  the previous view ("Previous view"), stop the analysis ("Stop"), go to the
  next sound file ("Next rec"), play the current view using external software 
  ("Play", see "player" argument), or delete the last manual selection in the
  current sound file ("Delete"). When a unit has been selected, the function 
  plots a red circle with the selection number in the middle point of the 
  selection in the spectrogram. It also plots vertical dotted lines at the 
  start and end of the selection. The circle and lines "disappear" when the 
  selection is deleted ("Delete" button). Only the last selection can be deleted. 
  
  The function produces a .csv file (manualoc_output.csv) with information about the .wav file name,
  selection number, start and end time, selection comment (selcomm), and
  sound file comment (reccomm). The file is saved in the working directory and
  is updated every time the user moves into the next sound file (Next rec
  "button") or stop the process (Stop "button"). When resuming the process
  (after "stop" and re-running the function in the same working directory),
  the function will keep the previous selections and will only pick up .wav
  files that are not present in the .csv file (not previously analyzed). When users 
  go to the next sound file (Next rec "button") without making any
  selection the file is still included in the .csv file, with NA's in the
  "end", "time" and "selec" field. 
  
  Windows length (wl) controls the temporal and frequency precision of the spectrogram. 
  A high "wl" value increases the frequency resolution but reduces the temporal resolution, and vice versa. Any
  color palette that comes with the seewave package can be used: temp.colors,
  reverse.gray.colors.1, reverse.gray.colors.2, reverse.heat.colors, reverse.terrain.colors,
  reverse.topo.colors, reverse.cm.colors, heat.colors, terrain.colors, topo.colors,
  cm.colors. The function is slow when working on files of length > 5min. In most cases other
  sound analysis softwares for manually selecting acoustic signals (e.g. Raven, Syrinx) should
  be prefered.
}
\examples{
\dontrun{
#Set temporary working directory
# setwd(tempdir())

# save wav file examples
data(list = c("Phae.long1", "Phae.long2", "Phae.long3", "Phae.long4"))
writeWave(Phae.long1,"Phae.long1.wav")
writeWave(Phae.long2,"Phae.long2.wav")
writeWave(Phae.long3,"Phae.long3.wav")
writeWave(Phae.long4,"Phae.long4.wav")

manualoc(wl = 300)
# need to use the buttoms to manipulate function
# check working directory for .csv file after stopping function
#check here:
getwd()
}
}
\seealso{
\code{\link{seltailor}}
}
\author{
Marcelo Araya-Salas (\email{araya-salas@cornell.edu})
}
