Data Integrity Check
================
Tristan Mahr
2016-07-25

In Spring 2015, we had our data-entry team re-enter test scores gathered in our studies, so that we could find data-entry discrepancies. This script compares the original to the re-entered scores.

Studies under consideration
---------------------------

Data from the following studies are checked:

    #> [1] "TimePoint1"       "TimePoint2"       "TimePoint3"      
    #> [4] "CochlearV1"       "CochlearV2"       "CochlearMatching"
    #> [7] "LateTalker"       "Medu"

Participant pool comparison
---------------------------

Do the same participants contribute scores in each set?

Participants in original score-set ("ParticipantInfo") *not in* the re-entered score-set ("DIRT"):

    #> # A tibble: 4 x 4
    #>        Study ParticipantID  DIRT ParticipantInfo
    #>        <chr>         <chr> <lgl>           <lgl>
    #> 1 CochlearV1          079L    NA            TRUE
    #> 2 CochlearV2          312E    NA            TRUE
    #> 3 LateTalker          206T    NA            TRUE
    #> 4 LateTalker          203T    NA            TRUE

Participants in re-entered score-set ("DIRT") who visited the lab but are *not in* the original score-set ("ParticipantInfo").

    #> # A tibble: 0 x 4
    #> # ... with 4 variables: Study <chr>, ParticipantID <chr>, DIRT <lgl>,
    #> #   ParticipantInfo <lgl>

Value Comparison
----------------

We now compare the scores in each score-set. This check is only being performed on participants in both score-sets.

### Summary

This table lists all the fields that were checked and whether any discrepancies were found in that field.

| Study            | Variable                                 | Passing |                      |
|:-----------------|:-----------------------------------------|:--------|----------------------|
| CochlearMatching | CTOPPMemory\_Date                        | TRUE    | :white\_check\_mark: |
| CochlearMatching | CTOPPMemory\_Raw                         | TRUE    | :white\_check\_mark: |
| CochlearMatching | CTOPPMemory\_Scaled                      | TRUE    | :white\_check\_mark: |
| CochlearMatching | EVT\_Date                                | TRUE    | :white\_check\_mark: |
| CochlearMatching | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| CochlearMatching | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| CochlearMatching | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| CochlearMatching | FruitStroop\_Score                       | TRUE    | :white\_check\_mark: |
| CochlearMatching | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| CochlearMatching | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| CochlearMatching | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| CochlearMatching | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| CochlearMatching | VerbalFluency\_AgeEquivalent             | TRUE    | :white\_check\_mark: |
| CochlearMatching | VerbalFluency\_Score                     | TRUE    | :white\_check\_mark: |
| CochlearV1       | EVT\_Date                                | FALSE   | :x:                  |
| CochlearV1       | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| CochlearV1       | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| CochlearV1       | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| CochlearV1       | FruitStroop\_Score                       | TRUE    | :white\_check\_mark: |
| CochlearV1       | PPVT\_Date                               | FALSE   | :x:                  |
| CochlearV1       | PPVT\_GSV                                | FALSE   | :x:                  |
| CochlearV1       | PPVT\_Raw                                | FALSE   | :x:                  |
| CochlearV1       | PPVT\_Standard                           | FALSE   | :x:                  |
| CochlearV1       | VerbalFluency\_AgeEquivalent             | TRUE    | :white\_check\_mark: |
| CochlearV1       | VerbalFluency\_Score                     | TRUE    | :white\_check\_mark: |
| CochlearV2       | EVT\_Date                                | FALSE   | :x:                  |
| CochlearV2       | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| CochlearV2       | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| CochlearV2       | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| CochlearV2       | FruitStroop\_Score                       | TRUE    | :white\_check\_mark: |
| CochlearV2       | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| CochlearV2       | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| CochlearV2       | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| CochlearV2       | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| CochlearV2       | VerbalFluency\_AgeEquivalent             | TRUE    | :white\_check\_mark: |
| CochlearV2       | VerbalFluency\_Score                     | TRUE    | :white\_check\_mark: |
| LateTalker       | CTOPPBlending\_Raw                       | TRUE    | :white\_check\_mark: |
| LateTalker       | CTOPPElision\_Raw                        | TRUE    | :white\_check\_mark: |
| LateTalker       | CTOPPMemory\_Date                        | TRUE    | :white\_check\_mark: |
| LateTalker       | CTOPPMemory\_Raw                         | TRUE    | :white\_check\_mark: |
| LateTalker       | CTOPPMemory\_Scaled                      | TRUE    | :white\_check\_mark: |
| LateTalker       | EVT\_Date                                | TRUE    | :white\_check\_mark: |
| LateTalker       | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| LateTalker       | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| LateTalker       | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| LateTalker       | FruitStroop\_Score                       | TRUE    | :white\_check\_mark: |
| LateTalker       | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| LateTalker       | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| LateTalker       | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| LateTalker       | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| LateTalker       | VerbalFluency\_AgeEquivalent             | TRUE    | :white\_check\_mark: |
| LateTalker       | VerbalFluency\_Score                     | TRUE    | :white\_check\_mark: |
| Medu             | CTOPPBlending\_Raw                       | TRUE    | :white\_check\_mark: |
| Medu             | CTOPPElision\_Raw                        | TRUE    | :white\_check\_mark: |
| Medu             | CTOPPMemory\_Date                        | FALSE   | :x:                  |
| Medu             | CTOPPMemory\_Raw                         | TRUE    | :white\_check\_mark: |
| Medu             | CTOPPMemory\_Scaled                      | TRUE    | :white\_check\_mark: |
| Medu             | DELV\_Date                               | FALSE   | :x:                  |
| Medu             | DELV\_LanguageRisk                       | TRUE    | :white\_check\_mark: |
| Medu             | DELV\_LanguageRisk\_DiagnosticErrorScore | TRUE    | :white\_check\_mark: |
| Medu             | DELV\_LanguageVar\_ColumnAScore          | TRUE    | :white\_check\_mark: |
| Medu             | DELV\_LanguageVar\_ColumnBScore          | TRUE    | :white\_check\_mark: |
| Medu             | EVT\_Date                                | FALSE   | :x:                  |
| Medu             | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| Medu             | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| Medu             | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| Medu             | FruitStroop\_Score                       | TRUE    | :white\_check\_mark: |
| Medu             | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| Medu             | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| Medu             | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| Medu             | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| Medu             | VerbalFluency\_AgeEquivalent             | TRUE    | :white\_check\_mark: |
| Medu             | VerbalFluency\_Score                     | FALSE   | :x:                  |
| TimePoint1       | EVT\_Date                                | TRUE    | :white\_check\_mark: |
| TimePoint1       | EVT\_Form                                | TRUE    | :white\_check\_mark: |
| TimePoint1       | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| TimePoint1       | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| TimePoint1       | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| TimePoint1       | FruitStroop\_Score                       | TRUE    | :white\_check\_mark: |
| TimePoint1       | GFTA\_Date                               | FALSE   | :x:                  |
| TimePoint1       | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| TimePoint1       | PPVT\_Form                               | TRUE    | :white\_check\_mark: |
| TimePoint1       | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| TimePoint1       | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| TimePoint1       | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| TimePoint1       | VerbalFluency\_AgeEquivalent             | TRUE    | :white\_check\_mark: |
| TimePoint1       | VerbalFluency\_Score                     | TRUE    | :white\_check\_mark: |
| TimePoint2       | CTOPPBlending\_Raw                       | TRUE    | :white\_check\_mark: |
| TimePoint2       | CTOPPBlending\_Scaled                    | TRUE    | :white\_check\_mark: |
| TimePoint2       | CTOPPElision\_Raw                        | TRUE    | :white\_check\_mark: |
| TimePoint2       | CTOPPElision\_Scaled                     | TRUE    | :white\_check\_mark: |
| TimePoint2       | EVT\_Date                                | TRUE    | :white\_check\_mark: |
| TimePoint2       | EVT\_Form                                | TRUE    | :white\_check\_mark: |
| TimePoint2       | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| TimePoint2       | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| TimePoint2       | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| TimePoint2       | FruitStroop\_Score                       | TRUE    | :white\_check\_mark: |
| TimePoint2       | KBIT\_Raw                                | TRUE    | :white\_check\_mark: |
| TimePoint2       | KBIT\_Standard                           | TRUE    | :white\_check\_mark: |
| TimePoint2       | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| TimePoint2       | PPVT\_Form                               | TRUE    | :white\_check\_mark: |
| TimePoint2       | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| TimePoint2       | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| TimePoint2       | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| TimePoint2       | VerbalFluency\_AgeEquivalent             | TRUE    | :white\_check\_mark: |
| TimePoint2       | VerbalFluency\_Score                     | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPBlending\_Raw                       | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPBlending\_Scaled                    | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPElision\_Raw                        | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPElision\_Scaled                     | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPMemory\_Date                        | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPMemory\_Raw                         | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPMemory\_Scaled                      | TRUE    | :white\_check\_mark: |
| TimePoint3       | DELV\_Date                               | TRUE    | :white\_check\_mark: |
| TimePoint3       | DELV\_LanguageRisk                       | TRUE    | :white\_check\_mark: |
| TimePoint3       | DELV\_LanguageRisk\_DiagnosticErrorScore | TRUE    | :white\_check\_mark: |
| TimePoint3       | DELV\_LanguageVar\_ColumnAScore          | TRUE    | :white\_check\_mark: |
| TimePoint3       | DELV\_LanguageVar\_ColumnBScore          | TRUE    | :white\_check\_mark: |
| TimePoint3       | EVT\_Date                                | TRUE    | :white\_check\_mark: |
| TimePoint3       | EVT\_Form                                | TRUE    | :white\_check\_mark: |
| TimePoint3       | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| TimePoint3       | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| TimePoint3       | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| TimePoint3       | GFTA\_Date                               | FALSE   | :x:                  |
| TimePoint3       | KBIT\_Raw                                | TRUE    | :white\_check\_mark: |
| TimePoint3       | KBIT\_Standard                           | TRUE    | :white\_check\_mark: |
| TimePoint3       | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| TimePoint3       | PPVT\_Form                               | TRUE    | :white\_check\_mark: |
| TimePoint3       | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| TimePoint3       | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| TimePoint3       | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| TimePoint3       | VerbalFluency\_AgeEquivalent             | TRUE    | :white\_check\_mark: |
| TimePoint3       | VerbalFluency\_Score                     | TRUE    | :white\_check\_mark: |

### Details

These are all the mismatching values.

    #> $CTOPPMemory_Date
    #>   Study ParticipantID         Variable       DIRT ParticipantInfo
    #> 1  Medu          509M CTOPPMemory_Date 2015-07-08      2015-06-29
    #> 
    #> $DELV_Date
    #>   Study ParticipantID  Variable       DIRT ParticipantInfo
    #> 1  Medu          508M DELV_Date 2015-05-27      2015-05-22
    #> 
    #> $EVT_Date
    #>        Study ParticipantID Variable       DIRT ParticipantInfo
    #> 1 CochlearV1          311E EVT_Date 2014-11-09      2013-11-09
    #> 2 CochlearV2          314E EVT_Date 2016-02-28      2016-02-08
    #> 3       Medu          506M EVT_Date 2015-05-18      2015-05-08
    #> 
    #> $GFTA_Date
    #>         Study ParticipantID  Variable       DIRT ParticipantInfo
    #> 1  TimePoint1          022L GFTA_Date 2013-05-20      2013-05-22
    #> 2  TimePoint1          075L GFTA_Date 2013-08-28      2013-09-14
    #> 3  TimePoint1          085L GFTA_Date 2013-10-02            <NA>
    #> 4  TimePoint1          110L GFTA_Date 2014-01-24      2014-02-14
    #> 5  TimePoint1          602L GFTA_Date 2012-12-11      2012-12-18
    #> 6  TimePoint1          616L GFTA_Date 2013-02-01            <NA>
    #> 7  TimePoint1          624L GFTA_Date  2013-4-11            <NA>
    #> 8  TimePoint1          631L GFTA_Date 2013-06-15            <NA>
    #> 9  TimePoint1          632L GFTA_Date 2013-06-21      2013-06-28
    #> 10 TimePoint1          645L GFTA_Date  2013-08-7      2013-08-07
    #> 11 TimePoint1          646L GFTA_Date  7/22/2013      2013-08-05
    #> 12 TimePoint3          600L GFTA_Date 2014-12-12            <NA>
    #> 13 TimePoint3          602L GFTA_Date 2014-12-18            <NA>
    #> 14 TimePoint3          604L GFTA_Date 2014-12-23            <NA>
    #> 15 TimePoint3          605L GFTA_Date 2014-11-15            <NA>
    #> 16 TimePoint3          607L GFTA_Date 2014-12-16            <NA>
    #> 17 TimePoint3          608L GFTA_Date 2014-12-30            <NA>
    #> 18 TimePoint3          609L GFTA_Date 2014-12-12            <NA>
    #> 19 TimePoint3          610L GFTA_Date 2014-11-21            <NA>
    #> 20 TimePoint3          611L GFTA_Date 2015-03-27            <NA>
    #> 21 TimePoint3          612L GFTA_Date 2015-01-26            <NA>
    #> 22 TimePoint3          614L GFTA_Date 2015-01-05            <NA>
    #> 23 TimePoint3          615L GFTA_Date 2015-05-21            <NA>
    #> 24 TimePoint3          616L GFTA_Date 2015-02-07            <NA>
    #> 25 TimePoint3          619L GFTA_Date 2015-02-28            <NA>
    #> 26 TimePoint3          620L GFTA_Date 2015-01-23            <NA>
    #> 27 TimePoint3          622L GFTA_Date 2015-03-12            <NA>
    #> 28 TimePoint3          623L GFTA_Date 2015-02-27            <NA>
    #> 29 TimePoint3          624L GFTA_Date 2015-03-06            <NA>
    #> 30 TimePoint3          625L GFTA_Date 2015-03-24            <NA>
    #> 31 TimePoint3          627L GFTA_Date 2015-02-07            <NA>
    #> 32 TimePoint3          628L GFTA_Date 2015-04-30            <NA>
    #> 33 TimePoint3          629L GFTA_Date 2015-05-08            <NA>
    #> 34 TimePoint3          630L GFTA_Date 2016-01-19            <NA>
    #> 35 TimePoint3          631L GFTA_Date 2015-06-13            <NA>
    #> 36 TimePoint3          632L GFTA_Date 2015-05-02            <NA>
    #> 37 TimePoint3          636L GFTA_Date 2015-05-11            <NA>
    #> 38 TimePoint3          638L GFTA_Date 2015-06-10            <NA>
    #> 39 TimePoint3          639L GFTA_Date 2015-06-09            <NA>
    #> 40 TimePoint3          640L GFTA_Date 2015-06-13            <NA>
    #> 41 TimePoint3          644L GFTA_Date 2015-08-21            <NA>
    #> 42 TimePoint3          651L GFTA_Date 2015-11-07            <NA>
    #> 43 TimePoint3          652L GFTA_Date 2015-07-30            <NA>
    #> 44 TimePoint3          655L GFTA_Date 2015-12-18            <NA>
    #> 45 TimePoint3          656L GFTA_Date 2015-07-27            <NA>
    #> 46 TimePoint3          657L GFTA_Date 2015-09-25            <NA>
    #> 47 TimePoint3          658L GFTA_Date 2015-09-01            <NA>
    #> 48 TimePoint3          659L GFTA_Date 2015-09-11            <NA>
    #> 49 TimePoint3          660L GFTA_Date 2015-11-14            <NA>
    #> 50 TimePoint3          661L GFTA_Date 2015-11-06            <NA>
    #> 51 TimePoint3          664L GFTA_Date 2015-11-11            <NA>
    #> 52 TimePoint3          665L GFTA_Date 2015-11-21            <NA>
    #> 53 TimePoint3          666L GFTA_Date 2015-10-08            <NA>
    #> 54 TimePoint3          667L GFTA_Date 2015-10-24            <NA>
    #> 55 TimePoint3          668L GFTA_Date 2015-10-10            <NA>
    #> 56 TimePoint3          669L GFTA_Date 2015-10-09            <NA>
    #> 57 TimePoint3          670L GFTA_Date 2015-09-25            <NA>
    #> 58 TimePoint3          671L GFTA_Date 2015-12-12            <NA>
    #> 59 TimePoint3          673L GFTA_Date 2015-12-19            <NA>
    #> 60 TimePoint3          674L GFTA_Date 2015-12-04            <NA>
    #> 61 TimePoint3          677L GFTA_Date 2016-01-05            <NA>
    #> 62 TimePoint3          678L GFTA_Date 2016-02-19            <NA>
    #> 63 TimePoint3          679L GFTA_Date 2016-03-09            <NA>
    #> 64 TimePoint3          680L GFTA_Date 2015-12-17            <NA>
    #> 65 TimePoint3          681L GFTA_Date 2016-02-09            <NA>
    #> 66 TimePoint3          683L GFTA_Date 2016-02-26            <NA>
    #> 67 TimePoint3          684L GFTA_Date 2016-01-30            <NA>
    #> 68 TimePoint3          685L GFTA_Date 2016-02-20            <NA>
    #> 69 TimePoint3          686L GFTA_Date 2016-02-20            <NA>
    #> 70 TimePoint3          689L GFTA_Date 2016-03-01            <NA>
    #> 
    #> $PPVT_Date
    #>        Study ParticipantID  Variable DIRT ParticipantInfo
    #> 1 CochlearV1          306E PPVT_Date <NA>      2014-08-09
    #> 
    #> $PPVT_GSV
    #>        Study ParticipantID Variable DIRT ParticipantInfo
    #> 1 CochlearV1          306E PPVT_GSV   NA              88
    #> 
    #> $PPVT_Raw
    #>        Study ParticipantID Variable DIRT ParticipantInfo
    #> 1 CochlearV1          306E PPVT_Raw   NA              32
    #> 
    #> $PPVT_Standard
    #>        Study ParticipantID      Variable DIRT ParticipantInfo
    #> 1 CochlearV1          306E PPVT_Standard   NA              74
    #> 
    #> $VerbalFluency_Score
    #>   Study ParticipantID            Variable DIRT ParticipantInfo
    #> 1  Medu          513M VerbalFluency_Score    3               0

### Unchecked fields

The following columns in DIRT were not checked because there is not a matching column in the participant info spreadsheets

| Study            | Variable                                 |                  |
|:-----------------|:-----------------------------------------|------------------|
| Medu             | CTOPPElision\_Date                       | :grey\_question: |
| Medu             | CTOPPElision\_Scaled                     | :grey\_question: |
| Medu             | CTOPPBlending\_Date                      | :grey\_question: |
| Medu             | CTOPPBlending\_Scaled                    | :grey\_question: |
| Medu             | DELV\_DegreeLanguageVar                  | :grey\_question: |
| TimePoint1       | VerbalFluency\_Date                      | :grey\_question: |
| TimePoint1       | FruitStroop\_Date                        | :grey\_question: |
| TimePoint1       | MBCDI\_Date                              | :grey\_question: |
| TimePoint1       | BRIEFP\_Date                             | :grey\_question: |
| TimePoint1       | CDI\_Extension\_Date                     | :grey\_question: |
| TimePoint2       | VerbalFluency\_Date                      | :grey\_question: |
| TimePoint2       | FruitStroop\_Date                        | :grey\_question: |
| TimePoint2       | CTOPPElision\_Date                       | :grey\_question: |
| TimePoint2       | CTOPPBlending\_Date                      | :grey\_question: |
| TimePoint2       | KBIT\_Date                               | :grey\_question: |
| TimePoint3       | VerbalFluency\_Date                      | :grey\_question: |
| TimePoint3       | CTOPPElision\_Date                       | :grey\_question: |
| TimePoint3       | CTOPPBlending\_Date                      | :grey\_question: |
| TimePoint3       | KBIT\_Date                               | :grey\_question: |
| TimePoint3       | DELV\_LanguageVar                        | :grey\_question: |
| TimePoint3       | DELV\_DegreeLanguageVar                  | :grey\_question: |
| LateTalker       | EVT\_Form                                | :grey\_question: |
| LateTalker       | GFTA\_Date                               | :grey\_question: |
| LateTalker       | VerbalFluency\_Date                      | :grey\_question: |
| LateTalker       | PPVT\_Form                               | :grey\_question: |
| LateTalker       | MBCDI\_Date                              | :grey\_question: |
| LateTalker       | CDI\_Extension\_Date                     | :grey\_question: |
| LateTalker       | BRIEFP\_Date                             | :grey\_question: |
| LateTalker       | FruitStroop\_Date                        | :grey\_question: |
| LateTalker       | CTOPPBlending\_Scaled                    | :grey\_question: |
| LateTalker       | CTOPPElision\_Date                       | :grey\_question: |
| LateTalker       | CTOPPElision\_Scaled                     | :grey\_question: |
| LateTalker       | CTOPPBlending\_Date                      | :grey\_question: |
| LateTalker       | DELV\_Date                               | :grey\_question: |
| LateTalker       | DELV\_LanguageVar\_ColumnAScore          | :grey\_question: |
| LateTalker       | DELV\_LanguageVar\_ColumnBScore          | :grey\_question: |
| LateTalker       | DELV\_LanguageRisk\_DiagnosticErrorScore | :grey\_question: |
| LateTalker       | DELV\_LanguageRisk                       | :grey\_question: |
| LateTalker       | DELV\_DegreeLanguageVar                  | :grey\_question: |
| CochlearV1       | EVT\_Form                                | :grey\_question: |
| CochlearV1       | VerbalFluency\_Date                      | :grey\_question: |
| CochlearV1       | GFTA\_Date                               | :grey\_question: |
| CochlearV1       | PPVT\_Form                               | :grey\_question: |
| CochlearV1       | CDI\_Extension\_Date                     | :grey\_question: |
| CochlearV1       | MBCDI\_Date                              | :grey\_question: |
| CochlearV1       | BRIEFP\_Date                             | :grey\_question: |
| CochlearV1       | FruitStroop\_Date                        | :grey\_question: |
| CochlearV1       | CTOPPMemory\_Date                        | :grey\_question: |
| CochlearV1       | CTOPPMemory\_Scaled                      | :grey\_question: |
| CochlearV1       | CTOPPMemory\_Raw                         | :grey\_question: |
| CochlearV1       | CDI W&G                                  | :grey\_question: |
| CochlearV2       | EVT\_Form                                | :grey\_question: |
| CochlearV2       | GFTA\_Date                               | :grey\_question: |
| CochlearV2       | VerbalFluency\_Date                      | :grey\_question: |
| CochlearV2       | PPVT\_Form                               | :grey\_question: |
| CochlearV2       | BRIEFP\_Date                             | :grey\_question: |
| CochlearV2       | MBCDI\_Date                              | :grey\_question: |
| CochlearV2       | CDI\_Extension\_Date                     | :grey\_question: |
| CochlearV2       | FruitStroop\_Date                        | :grey\_question: |
| CochlearV2       | CTOPPMemory\_Raw                         | :grey\_question: |
| CochlearV2       | CTOPPMemory\_Scaled                      | :grey\_question: |
| CochlearV2       | CTOPPMemory\_Date                        | :grey\_question: |
| CochlearMatching | EVT\_Form                                | :grey\_question: |
| CochlearMatching | VerbalFluency\_Date                      | :grey\_question: |
| CochlearMatching | GFTA\_Date                               | :grey\_question: |
| CochlearMatching | PPVT\_Form                               | :grey\_question: |
| CochlearMatching | BRIEFP\_Date                             | :grey\_question: |
| CochlearMatching | CDI\_Extension\_Date                     | :grey\_question: |
| CochlearMatching | MBCDI\_Date                              | :grey\_question: |
| CochlearMatching | FruitStroop\_Date                        | :grey\_question: |
| Medu             | EVT\_Form                                | :grey\_question: |
| Medu             | VerbalFluency\_Date                      | :grey\_question: |
| Medu             | FruitStroop\_Date                        | :grey\_question: |
| Medu             | MBCDI\_Date                              | :grey\_question: |
| Medu             | CDI\_Extension\_Date                     | :grey\_question: |
| Medu             | BRIEFP\_Date                             | :grey\_question: |
| Medu             | PPVT\_Form                               | :grey\_question: |
| Medu             | GFTA\_Date                               | :grey\_question: |
