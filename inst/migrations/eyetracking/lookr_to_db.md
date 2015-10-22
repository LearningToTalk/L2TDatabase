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
library("lookr")
library("purrr")
library("knitr")
library("dplyr")
opts_chunk$set(comment = "#>", collapse = TRUE)
```



```r
# Load some example data bundled in lookr
mp_long <- file.path(find.package("lookr"), "docs/data/MP_WFFArea_Long/")
trials <- suppressMessages(Task(mp_long))
trials
#> Task object with 2 Subject IDs and 144 trials: 
#>   SubjectID            Basename Trials
#> 1 001P00XA1 MP_Block1_001P00XA1     36
#> 2 001P00XA1 MP_Block2_001P00XA1     36
#> 3 001P00XS1 MP_Block1_001P00XS1     36
#> 4 001P00XS1 MP_Block2_001P00XS1     36

# Light preprocessing: Set time 0 to target onset, map gaze locations to AOIs,
# interpolate spans of missing data up to 150ms in duration
trials <- AdjustTimes(trials, "TargetOnset")
trials <- AddAOIData(trials)
trials <- InterpolateMissingFrames(trials)
```

Note that each `Trial` is a `data.frame` object with several associated
`attributes`.


```r
print(trials[[1]], width = 80, strict.width = "wrap")
#> Classes 'Trial' and 'data.frame':	407 obs. of  26 variables:
#> $ Task : chr "MP" "MP" "MP" "MP" ...
#> $ Subject : chr "001P00XA1" "001P00XA1" "001P00XA1" "001P00XA1" ...
#> $ BlockNo : int 1 1 1 1 1 1 1 1 1 1 ...
#> $ Basename : chr "MP_Block1_001P00XA1" "MP_Block1_001P00XA1"
#>    "MP_Block1_001P00XA1" "MP_Block1_001P00XA1" ...
#> $ TrialNo : int 1 1 1 1 1 1 1 1 1 1 ...
#> $ Time : num -3164 -3148 -3131 -3114 -3098 ...
#> $ XLeft : num NA NA 0.392 0.392 0.389 ...
#> $ XRight : num NA NA 0.388 0.386 0.374 ...
#> $ XMean : num NaN NaN 0.39 0.389 0.382 ...
#> $ YLeft : num NA NA 0.125 0.141 0.135 ...
#> $ YRight : num NA NA 0.16 0.167 0.152 ...
#> $ YMean : num NaN NaN 0.142 0.154 0.144 ...
#> $ ZLeft : num NA NA 592 592 592 ...
#> $ ZRight : num NA NA 594 594 594 ...
#> $ ZMean : num NaN NaN 593 593 593 ...
#> $ DiameterLeft : num NA NA 2.77 2.78 2.8 ...
#> $ DiameterRight : num NA NA 2.76 2.81 2.86 ...
#> $ DiameterMean : num NaN NaN 2.76 2.79 2.83 ...
#> $ YMeanToTarget : num NaN NaN 0.142 0.154 0.144 ...
#> $ YRightToTarget: num NA NA 0.16 0.167 0.152 ...
#> $ YLeftToTarget : num NA NA 0.125 0.141 0.135 ...
#> $ XMeanToTarget : num NaN NaN 0.39 0.389 0.382 ...
#> $ XRightToTarget: num NA NA 0.388 0.386 0.374 ...
#> $ XLeftToTarget : num NA NA 0.392 0.392 0.389 ...
#> $ GazeByAOI : chr NA NA "tracked" "tracked" ...
#> $ GazeByImageAOI: chr NA NA "tracked" "tracked" ...
#> - attr(*, "Task")= chr "MP"
#> - attr(*, "Protocol")= chr "WFF_Area"
#> - attr(*, "DateTime")= chr "2013-01-21 08:55:16"
#> - attr(*, "Subject")= chr "001P00XA1"
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
#> - attr(*, "ImageOnset")= num -3056
#> - attr(*, "Audio")= chr "AAE_girl_312_10"
#> - attr(*, "Attention")= chr "AAE_check2_10"
#> - attr(*, "AttentionDur")= num 914
#> - attr(*, "CarrierOnset")= num -968
#> - attr(*, "FixationOnset")= num -1503
#> - attr(*, "DelayTargetOnset")= num 8
#> - attr(*, "TargetOnset")= num 0
#> - attr(*, "TargetDur")= num 712
#> - attr(*, "CarrierDur")= num 960
#> - attr(*, "AttentionOnset")= num 1720
#> - attr(*, "Dialect")= chr "AAE"
#> - attr(*, "AttentionEnd")= num 2634
#> - attr(*, "FixationDur")= num 535
#> - attr(*, "CarrierEnd")= num -8
#> - attr(*, "TargetEnd")= num 712
#> - attr(*, "Basename")= chr "MP_Block1_001P00XA1"
#> - attr(*, "FrameRate")= num 16.7
#> - attr(*, "AlignedBy")= chr "TargetOnset"
#> - attr(*, "InterpolatedPoints")= num 21
#> - attr(*, "CorrectedFrames")= num 60 61 62 121 122 123 145 149 182 183 ...
#> - attr(*, "CorrectedTimes")= num -2182 -2165 -2148 -1166 -1149 ...
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

Now we can create the three main "wide" (task-invariant) tables


```r
tbl_exps <- trials %>% 
  gather_attributes(c("Basename", "DateTime", "Subject", "Task")) %>% 
  as_data_frame %>% 
  distinct
tbl_exps
#> Source: local data frame [4 x 4]
#> 
#>              Basename            DateTime   Subject  Task
#>                 (chr)               (chr)     (chr) (chr)
#> 1 MP_Block1_001P00XA1 2013-01-21 08:55:16 001P00XA1    MP
#> 2 MP_Block2_001P00XA1 2013-03-13 09:01:31 001P00XA1    MP
#> 3 MP_Block1_001P00XS1 2012-10-17 09:06:47 001P00XS1    MP
#> 4 MP_Block2_001P00XS1 2012-11-16 09:12:05 001P00XS1    MP

tbl_trials <- trials %>% 
  gather_attributes(c("TrialName", "Basename", "TrialNo")) %>% 
  as_data_frame %>% 
  distinct
tbl_trials
#> Source: local data frame [144 x 3]
#> 
#>                 TrialName            Basename TrialNo
#>                     (chr)               (chr)   (dbl)
#> 1  MP_Block1_001P00XA1_01 MP_Block1_001P00XA1       1
#> 2  MP_Block1_001P00XA1_02 MP_Block1_001P00XA1       2
#> 3  MP_Block1_001P00XA1_03 MP_Block1_001P00XA1       3
#> 4  MP_Block1_001P00XA1_04 MP_Block1_001P00XA1       4
#> 5  MP_Block1_001P00XA1_05 MP_Block1_001P00XA1       5
#> 6  MP_Block1_001P00XA1_06 MP_Block1_001P00XA1       6
#> 7  MP_Block1_001P00XA1_07 MP_Block1_001P00XA1       7
#> 8  MP_Block1_001P00XA1_08 MP_Block1_001P00XA1       8
#> 9  MP_Block1_001P00XA1_09 MP_Block1_001P00XA1       9
#> 10 MP_Block1_001P00XA1_10 MP_Block1_001P00XA1      10
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
tbl_looks
#> Source: local data frame [60,825 x 6]
#> 
#>                 TrialName      Time XMean YMean GazeByImageAOI GazeByAOI
#>                     (chr)     (dbl) (dbl) (dbl)          (chr)     (chr)
#> 1  MP_Block1_001P00XA1_01 -3164.374   NaN   NaN             NA        NA
#> 2  MP_Block1_001P00XA1_01 -3147.719   NaN   NaN             NA        NA
#> 3  MP_Block1_001P00XA1_01 -3131.065   749   171        tracked   tracked
#> 4  MP_Block1_001P00XA1_01 -3114.410   747   185        tracked   tracked
#> 5  MP_Block1_001P00XA1_01 -3097.756   732   172        tracked   tracked
#> 6  MP_Block1_001P00XA1_01 -3081.101   752   189        tracked   tracked
#> 7  MP_Block1_001P00XA1_01 -3064.446   741   185        tracked   tracked
#> 8  MP_Block1_001P00XA1_01 -3047.792   742   180        tracked   tracked
#> 9  MP_Block1_001P00XA1_01 -3031.137   742   181        tracked   tracked
#> 10 MP_Block1_001P00XA1_01 -3014.483   746   186        tracked   tracked
#> ..                    ...       ...   ...   ...            ...       ...
```


## Creating the grab-bag tables

### Prepare experimental grab-bag and flatten AOI definitions

Now we need to make the grab-bags of trial and experiment attributes. But first
let's unpack the implicit AOI definitions used in the experiments.


```r
library("tidyr")
#> Warning: package 'tidyr' was built under R version 3.2.2
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
#> Source: local data frame [32 x 3]
#> 
#>               Basename                     Key Value
#>                  (chr)                   (chr) (chr)
#> 1  MP_Block1_001P00XA1 AOI_Boundary_ImageL_x_1   100
#> 2  MP_Block2_001P00XA1 AOI_Boundary_ImageL_x_1   100
#> 3  MP_Block1_001P00XS1 AOI_Boundary_ImageL_x_1   100
#> 4  MP_Block2_001P00XS1 AOI_Boundary_ImageL_x_1   100
#> 5  MP_Block1_001P00XA1 AOI_Boundary_ImageL_x_2   700
#> 6  MP_Block2_001P00XA1 AOI_Boundary_ImageL_x_2   700
#> 7  MP_Block1_001P00XS1 AOI_Boundary_ImageL_x_2   700
#> 8  MP_Block2_001P00XS1 AOI_Boundary_ImageL_x_2   700
#> 9  MP_Block1_001P00XA1 AOI_Boundary_ImageL_y_1   300
#> 10 MP_Block2_001P00XA1 AOI_Boundary_ImageL_y_1   300
#> ..                 ...                     ...   ...

# Combine AOI attributes with other ones
tbl_exps_attrs <- bind_rows(tbl_exps_gb, aoi_rows) %>% 
  arrange(Basename, Key)
tbl_exps_attrs
#> Source: local data frame [52 x 3]
#> 
#>               Basename                     Key   Value
#>                  (chr)                   (chr)   (chr)
#> 1  MP_Block1_001P00XA1 AOI_Boundary_ImageL_x_1     100
#> 2  MP_Block1_001P00XA1 AOI_Boundary_ImageL_x_2     700
#> 3  MP_Block1_001P00XA1 AOI_Boundary_ImageL_y_1     300
#> 4  MP_Block1_001P00XA1 AOI_Boundary_ImageL_y_2     900
#> 5  MP_Block1_001P00XA1 AOI_Boundary_ImageR_x_1    1220
#> 6  MP_Block1_001P00XA1 AOI_Boundary_ImageR_x_2    1820
#> 7  MP_Block1_001P00XA1 AOI_Boundary_ImageR_y_1     300
#> 8  MP_Block1_001P00XA1 AOI_Boundary_ImageR_y_2     900
#> 9  MP_Block1_001P00XA1                 Dialect     AAE
#> 10 MP_Block1_001P00XA1               FrameRate 16.6546
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

```

