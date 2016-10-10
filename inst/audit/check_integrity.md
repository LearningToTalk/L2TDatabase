Data Integrity Check
================
Tristan Mahr
2016-10-10

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

    #> # A tibble: 4 × 4
    #>        Study ParticipantID  DIRT ParticipantInfo
    #>        <chr>         <chr> <lgl>           <lgl>
    #> 1 CochlearV1          079L    NA            TRUE
    #> 2 CochlearV2          312E    NA            TRUE
    #> 3 LateTalker          206T    NA            TRUE
    #> 4 LateTalker          203T    NA            TRUE

Participants in re-entered score-set ("DIRT") who visited the lab but are *not in* the original score-set ("ParticipantInfo").

    #> # A tibble: 0 × 4
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
| TimePoint1       | EVT\_Date                                | FALSE   | :x:                  |
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
| TimePoint3       | KBIT\_Standard                           | FALSE   | :x:                  |
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
    #> 4 TimePoint1          016L EVT_Date  2013-1-07      2013-01-07
    #> 5 TimePoint1          604L EVT_Date 2012-11-09      2010-11-09
    #> 6 TimePoint1          634L EVT_Date  2013-9-27      2013-09-27
    #> 
    #> $GFTA_Date
    #>         Study ParticipantID  Variable       DIRT ParticipantInfo
    #> 1  TimePoint1          022L GFTA_Date 2013-05-20      2013-05-22
    #> 2  TimePoint1          075L GFTA_Date 2013-08-28      2013-09-14
    #> 3  TimePoint1          085L GFTA_Date 2013-10-02            <NA>
    #> 4  TimePoint1          110L GFTA_Date 2014-01-24      2014-02-14
    #> 5  TimePoint1          602L GFTA_Date 2012-12-11      2012-12-08
    #> 6  TimePoint1          616L GFTA_Date 2013-02-01            <NA>
    #> 7  TimePoint1          624L GFTA_Date  2013-4-11            <NA>
    #> 8  TimePoint1          631L GFTA_Date 2013-06-15            <NA>
    #> 9  TimePoint1          632L GFTA_Date 2013-06-21      2013-06-28
    #> 10 TimePoint1          645L GFTA_Date  2013-08-7      2013-08-07
    #> 11 TimePoint1          646L GFTA_Date  7/22/2013      2013-08-05
    #> 12 TimePoint3          658L GFTA_Date 2015-09-01      2015-08-31
    #> 
    #> $KBIT_Standard
    #>        Study ParticipantID      Variable DIRT ParticipantInfo
    #> 1 TimePoint3          615L KBIT_Standard  129             124
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
