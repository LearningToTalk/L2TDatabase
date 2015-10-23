# Normalizing Eyetracking Data
Tristan Mahr  
October 22, 2015  

## Gameplan

Our goal today is to prepare our eyetracking data to be inserted into a
database.

For database normalization, we want there to be five tables:

* Experiments: 1 row per administration of experiment.
* Trials: 1 row per trial of an eye-tracking experiment.
* Frames: 1 row per frame of eyetracking data in a trial.
* ExperimentsInfo: 1 row per attribute of a experiment
* TrialInfo: 1 row per attribute of a trial

The first three tables are meant to be nice and nested "wide" dataframes. We 
have looks nested in trials nested in experiment administrations, and each row 
is one thing (a frame, a trial, an experiment). These three tables are
experiment agnostic.

The other tables are meant to be a grab-bag of key-value pairs, containing 
things like the target word of each trial or the dialect of the experiment 
administration. These will be "long" dataframes, such that there are multiple 
rows for a single trial or experiment. The specific attributes that 
differentiate trials and experiments live in these tables. These tables will
allow the other three to be completely task agnostic.

## Eyetracking data from lookr

Use lookr to load and reduce some eye-tracking data.


```r
library("knitr")
library("lookr")
library("purrr") # manipulate lists
library("dplyr") # manipulate tables
library("tidyr") # wide/long tables

opts_chunk$set(comment = "#>", collapse = TRUE)
```



```r
# Load some example data bundled in lookr
mp_long <- "MP_TP1"
trials <- Task(mp_long)
#> Reading stimdata in MP_TP1/001L/MP_Block1_001L28FS1.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/001L/MP_Block2_001L28FS1.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/002L/MP_Block1_002L38FS2.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/002L/MP_Block2_002L38FS2.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/003L/MP_Block1_003L31FS1.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/003L/MP_Block2_003L31FS1.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/004L/MP_Block1_004L32FS1.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/004L/MP_Block2_004L32FS1.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/005L/MP_Block1_005L31MS1.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/005L/MP_Block2_005L31MS1.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/006L/MP_Block1_006L28FS1.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/006L/MP_Block2_006L28FS1.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/007L/MP_Block1_007L32FS1.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/007L/MP_Block2_007L32FS1.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/008L/MP_Block1_008L30MS1.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/008L/MP_Block2_008L30MS1.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/009L/MP_Block1_009L31FS1.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/009L/MP_Block2_009L31FS1.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/010L/MP_Block1_010L32MS1.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/010L/MP_Block2_010L32MS1.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/011L/MP_Block1_011L36MS2.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/011L/MP_Block2_011L36MS2.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/012L/MP_Block1_012L30MS1.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/012L/MP_Block2_012L30MS1.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/013L/MP_Block1_013L32MA1.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: AAE
#> Reading stimdata in MP_TP1/013L/MP_Block2_013L32MA1.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: AAE
#> Reading stimdata in MP_TP1/014L/MP_Block1_014L39MS2.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/014L/MP_Block2_014L39MS2.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/020L/MP_Block1_020L37FS2.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
#> Reading stimdata in MP_TP1/020L/MP_Block2_020L37FS2.txt
#> Task: MP,  Protocol: WFF_Area,  Dialect: SAE
trials
#> Task object with 15 Subject IDs and 1080 trials: 
#>    SubjectID            Basename Trials
#> 1  001L28FS1 MP_Block1_001L28FS1     36
#> 2  001L28FS1 MP_Block2_001L28FS1     36
#> 3  002L38FS2 MP_Block1_002L38FS2     36
#> 4  002L38FS2 MP_Block2_002L38FS2     36
#> 5  003L31FS1 MP_Block1_003L31FS1     36
#> 6  003L31FS1 MP_Block2_003L31FS1     36
#> 7  004L32FS1 MP_Block1_004L32FS1     36
#> 8  004L32FS1 MP_Block2_004L32FS1     36
#> 9  005L31MS1 MP_Block1_005L31MS1     36
#> 10 005L31MS1 MP_Block2_005L31MS1     36
#> 11 006L28FS1 MP_Block1_006L28FS1     36
#> 12 006L28FS1 MP_Block2_006L28FS1     36
#> 13 007L32FS1 MP_Block1_007L32FS1     36
#> 14 007L32FS1 MP_Block2_007L32FS1     36
#> 15 008L30MS1 MP_Block1_008L30MS1     36
#> 16 008L30MS1 MP_Block2_008L30MS1     36
#> 17 009L31FS1 MP_Block1_009L31FS1     36
#> 18 009L31FS1 MP_Block2_009L31FS1     36
#> 19 010L32MS1 MP_Block1_010L32MS1     36
#> 20 010L32MS1 MP_Block2_010L32MS1     36
#> 21 011L36MS2 MP_Block1_011L36MS2     36
#> 22 011L36MS2 MP_Block2_011L36MS2     36
#> 23 012L30MS1 MP_Block1_012L30MS1     36
#> 24 012L30MS1 MP_Block2_012L30MS1     36
#> 25 013L32MA1 MP_Block1_013L32MA1     36
#> 26 013L32MA1 MP_Block2_013L32MA1     36
#> 27 014L39MS2 MP_Block1_014L39MS2     36
#> 28 014L39MS2 MP_Block2_014L39MS2     36
#> 29 020L37FS2 MP_Block1_020L37FS2     36
#> 30 020L37FS2 MP_Block2_020L37FS2     36

# Light preprocessing: Set time 0 to target onset, map gaze locations to AOIs,
# interpolate spans of missing data up to 150ms in duration
trials <- AdjustTimes(trials, "TargetOnset")
trials <- AddAOIData(trials)
trials <- InterpolateMissingFrames(trials)
```

Note that each `Trial` object is just `data.frame` with several associated
`attributes`.


```r
print(trials[[1]], width = 80, strict.width = "wrap")
#> Classes 'Trial' and 'data.frame':	449 obs. of  26 variables:
#> $ Task : chr "MP" "MP" "MP" "MP" ...
#> $ Subject : chr "001L28FS1" "001L28FS1" "001L28FS1" "001L28FS1" ...
#> $ BlockNo : int 1 1 1 1 1 1 1 1 1 1 ...
#> $ Basename : chr "MP_Block1_001L28FS1" "MP_Block1_001L28FS1"
#>    "MP_Block1_001L28FS1" "MP_Block1_001L28FS1" ...
#> $ TrialNo : int 1 1 1 1 1 1 1 1 1 1 ...
#> $ Time : num -3464 -3448 -3431 -3414 -3398 ...
#> $ XLeft : num NA NA NA NA NA NA NA NA NA NA ...
#> $ XRight : num NA NA NA NA NA NA NA NA NA NA ...
#> $ XMean : num NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ...
#> $ YLeft : num NA NA NA NA NA NA NA NA NA NA ...
#> $ YRight : num NA NA NA NA NA NA NA NA NA NA ...
#> $ YMean : num NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ...
#> $ ZLeft : num NA NA NA NA NA NA NA NA NA NA ...
#> $ ZRight : num NA NA NA NA NA NA NA NA NA NA ...
#> $ ZMean : num NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ...
#> $ DiameterLeft : num NA NA NA NA NA NA NA NA NA NA ...
#> $ DiameterRight : num NA NA NA NA NA NA NA NA NA NA ...
#> $ DiameterMean : num NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ...
#> $ YMeanToTarget : num NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ...
#> $ YRightToTarget: num NA NA NA NA NA NA NA NA NA NA ...
#> $ YLeftToTarget : num NA NA NA NA NA NA NA NA NA NA ...
#> $ XMeanToTarget : num NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ...
#> $ XRightToTarget: num NA NA NA NA NA NA NA NA NA NA ...
#> $ XLeftToTarget : num NA NA NA NA NA NA NA NA NA NA ...
#> $ GazeByAOI : chr NA NA NA NA ...
#> $ GazeByImageAOI: chr NA NA NA NA ...
#> - attr(*, "Task")= chr "MP"
#> - attr(*, "Protocol")= chr "WFF_Area"
#> - attr(*, "DateTime")= chr "2013-07-10 09:59:38"
#> - attr(*, "Subject")= chr "001L28FS1"
#> - attr(*, "Block")= num 1
#> - attr(*, "TrialNo")= num 1
#> - attr(*, "TargetWord")= chr "girl"
#> - attr(*, "ImageL")= chr "marmoset1"
#> - attr(*, "ImageR")= chr "girl1"
#> - attr(*, "TargetImage")= chr "ImageR"
#> - attr(*, "DistractorImage")= chr "ImageL"
#> - attr(*, "FamiliarImage")= chr "girl1"
#> - attr(*, "UnfamiliarImage")= chr "marmoset1"
#> - attr(*, "WordGroup")= chr "girl"
#> - attr(*, "StimType")= chr "real"
#> - attr(*, "ImageOnset")= num -3357
#> - attr(*, "Audio")= chr "SAE_girl_112_26"
#> - attr(*, "Attention")= chr "SAE_Check_3_1"
#> - attr(*, "AttentionDur")= num 1264
#> - attr(*, "CarrierOnset")= num -1336
#> - attr(*, "FixationOnset")= num -1803
#> - attr(*, "DelayTargetOnset")= num 3
#> - attr(*, "TargetOnset")= num 0
#> - attr(*, "TargetDur")= num 767
#> - attr(*, "CarrierDur")= num 1333
#> - attr(*, "AttentionOnset")= num 1770
#> - attr(*, "Dialect")= chr "SAE"
#> - attr(*, "AttentionEnd")= num 3034
#> - attr(*, "FixationDur")= num 467
#> - attr(*, "CarrierEnd")= num -3
#> - attr(*, "TargetEnd")= num 767
#> - attr(*, "Basename")= chr "MP_Block1_001L28FS1"
#> - attr(*, "FrameRate")= num 16.7
#> - attr(*, "AlignedBy")= chr "TargetOnset"
#> - attr(*, "InterpolatedPoints")= num 2
#> - attr(*, "CorrectedFrames")= num 34 35
#> - attr(*, "CorrectedTimes")= num -2915 -2898
#> - attr(*, "InterpolationWindow")= num 150
```

Extracting just the data-frame parts and combining them will provide us with the
rows for the Frames table. The Experiments/Trials rows will come from the
attributes. 

To link trials to administrations, we will create a new attribute `TrialName`
attibute that will uniquely identify trials.


```r
# Uniquely name each trial
trials %@% "TrialName" <- 
  sprintf("%s_%02.0f", trials %@% "Basename", trials %@% "TrialNo")
```

## Creating the wide tables

Now we can create the three main "wide" (task-invariant) tables. We `Basename`
to link experiment administrations to `TrialName` and `TrialName` to link to
eye-tracking frames.


```r
tbl_exps <- trials %>% 
  gather_attributes(c("Basename", "DateTime", "Subject", "Task")) %>% 
  as_data_frame %>% 
  distinct
tbl_exps
#> Source: local data frame [30 x 4]
#> 
#>               Basename            DateTime   Subject  Task
#>                  (chr)               (chr)     (chr) (chr)
#> 1  MP_Block1_001L28FS1 2013-07-10 09:59:38 001L28FS1    MP
#> 2  MP_Block2_001L28FS1 2013-07-03 09:17:43 001L28FS1    MP
#> 3  MP_Block1_002L38FS2 2012-10-17 09:06:47 002L38FS2    MP
#> 4  MP_Block2_002L38FS2 2012-11-16 09:12:05 002L38FS2    MP
#> 5  MP_Block1_003L31FS1 2012-11-27 12:26:35 003L31FS1    MP
#> 6  MP_Block2_003L31FS1 2012-11-02 09:04:09 003L31FS1    MP
#> 7  MP_Block1_004L32FS1 2012-10-22 16:26:49 004L32FS1    MP
#> 8  MP_Block2_004L32FS1 2012-10-29 16:53:30 004L32FS1    MP
#> 9  MP_Block1_005L31MS1 2012-12-07 16:07:24 005L31MS1    MP
#> 10 MP_Block2_005L31MS1 2012-10-24 09:00:58 005L31MS1    MP
#> ..                 ...                 ...       ...   ...

tbl_trials <- trials %>% 
  gather_attributes(c("TrialName", "Basename", "TrialNo")) %>% 
  as_data_frame %>% 
  distinct
tbl_trials
#> Source: local data frame [1,080 x 3]
#> 
#>                 TrialName            Basename TrialNo
#>                     (chr)               (chr)   (dbl)
#> 1  MP_Block1_001L28FS1_01 MP_Block1_001L28FS1       1
#> 2  MP_Block1_001L28FS1_02 MP_Block1_001L28FS1       2
#> 3  MP_Block1_001L28FS1_03 MP_Block1_001L28FS1       3
#> 4  MP_Block1_001L28FS1_04 MP_Block1_001L28FS1       4
#> 5  MP_Block1_001L28FS1_05 MP_Block1_001L28FS1       5
#> 6  MP_Block1_001L28FS1_06 MP_Block1_001L28FS1       6
#> 7  MP_Block1_001L28FS1_07 MP_Block1_001L28FS1       7
#> 8  MP_Block1_001L28FS1_08 MP_Block1_001L28FS1       8
#> 9  MP_Block1_001L28FS1_09 MP_Block1_001L28FS1       9
#> 10 MP_Block1_001L28FS1_10 MP_Block1_001L28FS1      10
#> ..                    ...                 ...     ...

# Make a function that extracts the columns of gaze data from a Trial, then 
# apply it to each Trial
collect_looks <- function(x) {
  x_name <- x %@% "TrialName"
  # c(x) to strip attributes
  x <- c(x) %>% 
    as_data_frame %>% 
    mutate(TrialName = x_name) %>% 
    select(TrialName, Time, XMean, YMean, GazeByImageAOI, GazeByAOI)
  x
}

looks <- trials %>% map(collect_looks) %>% bind_rows

# Convert screen proportions to pixel locations
tbl_looks <- looks %>% 
  mutate(XMean = round(XMean * lwl_constants$screen_width),
         YMean = round(YMean * lwl_constants$screen_height))
pryr::object_size(tbl_looks)
#> 23.2 MB
tbl_looks
#> Source: local data frame [480,744 x 6]
#> 
#>                 TrialName      Time XMean YMean GazeByImageAOI GazeByAOI
#>                     (chr)     (dbl) (dbl) (dbl)          (chr)     (chr)
#> 1  MP_Block1_001L28FS1_01 -3464.157   NaN   NaN             NA        NA
#> 2  MP_Block1_001L28FS1_01 -3447.502   NaN   NaN             NA        NA
#> 3  MP_Block1_001L28FS1_01 -3430.848   NaN   NaN             NA        NA
#> 4  MP_Block1_001L28FS1_01 -3414.193   NaN   NaN             NA        NA
#> 5  MP_Block1_001L28FS1_01 -3397.538   NaN   NaN             NA        NA
#> 6  MP_Block1_001L28FS1_01 -3380.884   NaN   NaN             NA        NA
#> 7  MP_Block1_001L28FS1_01 -3364.229   NaN   NaN             NA        NA
#> 8  MP_Block1_001L28FS1_01 -3347.575   NaN   NaN             NA        NA
#> 9  MP_Block1_001L28FS1_01 -3330.920   NaN   NaN             NA        NA
#> 10 MP_Block1_001L28FS1_01 -3314.265   NaN   NaN             NA        NA
#> ..                    ...       ...   ...   ...            ...       ...
```


## Creating the grab-bag tables

### Prepare experimental grab-bag and flatten AOI definitions

Now we need to make the grab-bags of trial and experiment attributes. But first
let's unpack the implicit AOI definitions used in the experiments.


```r
library("tidyr")
library("stringr")

# hard-coded inside lookr:::GetImageAOI
AOIs <- list(
  UpperLeftImage = list(x_pix = c(410, 860), y_pix = c(700, 1150)), 
  LowerLeftImage = list(x_pix = c(410, 860), y_pix = c(50, 500)), 
  UpperRightImage = list(x_pix = c(1060, 1510), y_pix = c(700, 1150)), 
  LowerRightImage = list(x_pix = c(1060, 1510), y_pix = c(50, 500)), 
  FixationImage = list(x_pix = c(885, 1035), y_pix = c(525, 675)), 
  ImageL = list(x_pix = c(100, 700), y_pix = c(300, 900)), 
  ImageR = list(x_pix = c(1220, 1820), y_pix = c(300, 900)))

# Break apart names from unlist(...) into separate columns
aoi_table <- unlist(AOIs) %>% 
  data_frame(Image = names(.), Pixel = .) %>% 
  separate(Image, into = c("AOI", "Dimension", "Number")) %>% 
  mutate(Number = str_replace(Number, "pix", ""),
         AOIBoundary = "AOI_Boundary")
  
# Keep only values used in the data and combine columns into Key, Value
aoi_table <- aoi_table %>% 
  filter(AOI %in% unique(looks$GazeByAOI)) %>% 
  unite(col = AOI_Boundary, AOIBoundary, AOI:Number) %>% 
  rename(Key = AOI_Boundary, Value = Pixel)
aoi_table
#> Source: local data frame [8 x 2]
#> 
#>                       Key Value
#>                     (chr) (dbl)
#> 1 AOI_Boundary_ImageL_x_1   100
#> 2 AOI_Boundary_ImageL_x_2   700
#> 3 AOI_Boundary_ImageL_y_1   300
#> 4 AOI_Boundary_ImageL_y_2   900
#> 5 AOI_Boundary_ImageR_x_1  1220
#> 6 AOI_Boundary_ImageR_x_2  1820
#> 7 AOI_Boundary_ImageR_y_1   300
#> 8 AOI_Boundary_ImageR_y_2   900
```

Now we assembly the experiment key-value grab-bag and attach the AOI definitions.


```r
# Gather experiment attributes
tbl_exps_gb <- trials %>% 
  gather_attributes(c("Basename", "Dialect", "Protocol")) %>% 
  as_data_frame %>% 
  distinct %>% 
  # Other hard-wired constants
  mutate(FrameRate = lwl_constants$ms_per_frame,
         ScreenWidth = lwl_constants$screen_width,
         ScreenHeight = lwl_constants$screen_height) %>% 
  gather(key = Key, value = Value, -Basename) 

# Create all combinations of basename and AOI property name
aoi_rows <- list(Basename = tbl_exps$Basename, Key = aoi_table$Key) %>% 
  cross_n %>% 
  bind_rows %>% 
  left_join(aoi_table) %>% 
  mutate(Value = as.character(Value))
#> Joining by: "Key"
aoi_rows
#> Source: local data frame [240 x 3]
#> 
#>               Basename                     Key Value
#>                  (chr)                   (chr) (chr)
#> 1  MP_Block1_001L28FS1 AOI_Boundary_ImageL_x_1   100
#> 2  MP_Block2_001L28FS1 AOI_Boundary_ImageL_x_1   100
#> 3  MP_Block1_002L38FS2 AOI_Boundary_ImageL_x_1   100
#> 4  MP_Block2_002L38FS2 AOI_Boundary_ImageL_x_1   100
#> 5  MP_Block1_003L31FS1 AOI_Boundary_ImageL_x_1   100
#> 6  MP_Block2_003L31FS1 AOI_Boundary_ImageL_x_1   100
#> 7  MP_Block1_004L32FS1 AOI_Boundary_ImageL_x_1   100
#> 8  MP_Block2_004L32FS1 AOI_Boundary_ImageL_x_1   100
#> 9  MP_Block1_005L31MS1 AOI_Boundary_ImageL_x_1   100
#> 10 MP_Block2_005L31MS1 AOI_Boundary_ImageL_x_1   100
#> ..                 ...                     ...   ...

# Combine AOI attributes with other ones
tbl_exps_attrs <- bind_rows(tbl_exps_gb, aoi_rows) %>% 
  arrange(Basename, Key)
tbl_exps_attrs
#> Source: local data frame [390 x 3]
#> 
#>               Basename                     Key   Value
#>                  (chr)                   (chr)   (chr)
#> 1  MP_Block1_001L28FS1 AOI_Boundary_ImageL_x_1     100
#> 2  MP_Block1_001L28FS1 AOI_Boundary_ImageL_x_2     700
#> 3  MP_Block1_001L28FS1 AOI_Boundary_ImageL_y_1     300
#> 4  MP_Block1_001L28FS1 AOI_Boundary_ImageL_y_2     900
#> 5  MP_Block1_001L28FS1 AOI_Boundary_ImageR_x_1    1220
#> 6  MP_Block1_001L28FS1 AOI_Boundary_ImageR_x_2    1820
#> 7  MP_Block1_001L28FS1 AOI_Boundary_ImageR_y_1     300
#> 8  MP_Block1_001L28FS1 AOI_Boundary_ImageR_y_2     900
#> 9  MP_Block1_001L28FS1                 Dialect     SAE
#> 10 MP_Block1_001L28FS1               FrameRate 16.6546
#> ..                 ...                     ...     ...
```

### Prepare trial grab-bag

Now we can do the trials attributes.


```r
trial_attrs <- 
  c("TrialName", "StimType", "WordGroup", "TargetWord",
    "TargetImage", "DistractorImage", "ImageL", "ImageR", 
    "FamiliarImage", "UnfamiliarImage", 
    "Audio", "Attention", "InterpolationWindow",
    # trial events
    "ImageOnset",
    "FixationOnset", "FixationDur", 
    "CarrierOnset", "CarrierEnd",
    "TargetOnset", "TargetEnd", 
    "AttentionOnset", "AttentionEnd")

tbl_trial_attrs <- trials %>% 
  gather_attributes(trial_attrs, omit_na = TRUE) %>% 
  as_data_frame %>% 
  gather(Key, Value, -TrialName) %>% 
  arrange(TrialName, Key) %>% 
  mutate(Key = as.character(Key))
pryr::object_size(tbl_trial_attrs)
#> 661 kB
```

Now these tables can be inserted into the database with the following steps.
