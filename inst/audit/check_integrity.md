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
| CochlearV2       | PPVT\_Date                               | FALSE   | :x:                  |
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
| LateTalker       | EVT\_Date                                | FALSE   | :x:                  |
| LateTalker       | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| LateTalker       | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| LateTalker       | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| LateTalker       | FruitStroop\_Score                       | TRUE    | :white\_check\_mark: |
| LateTalker       | PPVT\_Date                               | FALSE   | :x:                  |
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
| Medu             | PPVT\_Date                               | FALSE   | :x:                  |
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
| TimePoint1       | PPVT\_Date                               | FALSE   | :x:                  |
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
| TimePoint3       | CTOPPMemory\_Date                        | FALSE   | :x:                  |
| TimePoint3       | CTOPPMemory\_Raw                         | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPMemory\_Scaled                      | TRUE    | :white\_check\_mark: |
| TimePoint3       | DELV\_Date                               | FALSE   | :x:                  |
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
    #>         Study ParticipantID         Variable       DIRT ParticipantInfo
    #> 1        Medu          509M CTOPPMemory_Date 2015-07-08      2015-06-29
    #> 2        Medu          553M CTOPPMemory_Date 2015-07-31            <NA>
    #> 3  TimePoint3          600L CTOPPMemory_Date 2014-12-12            <NA>
    #> 4  TimePoint3          602L CTOPPMemory_Date 2014-12-18            <NA>
    #> 5  TimePoint3          604L CTOPPMemory_Date 2014-12-01            <NA>
    #> 6  TimePoint3          605L CTOPPMemory_Date 2014-11-15            <NA>
    #> 7  TimePoint3          607L CTOPPMemory_Date 2014-12-16            <NA>
    #> 8  TimePoint3          608L CTOPPMemory_Date 2014-12-22            <NA>
    #> 9  TimePoint3          609L CTOPPMemory_Date 2014-12-12            <NA>
    #> 10 TimePoint3          610L CTOPPMemory_Date 2014-11-21            <NA>
    #> 11 TimePoint3          611L CTOPPMemory_Date 2015-03-13            <NA>
    #> 12 TimePoint3          612L CTOPPMemory_Date 2015-01-26            <NA>
    #> 13 TimePoint3          614L CTOPPMemory_Date 2015-01-05            <NA>
    #> 14 TimePoint3          615L CTOPPMemory_Date 2015-05-04            <NA>
    #> 15 TimePoint3          616L CTOPPMemory_Date 2015-01-15            <NA>
    #> 16 TimePoint3          619L CTOPPMemory_Date 2015-04-04            <NA>
    #> 17 TimePoint3          620L CTOPPMemory_Date 2015-01-16            <NA>
    #> 18 TimePoint3          622L CTOPPMemory_Date 2015-02-28            <NA>
    #> 19 TimePoint3          623L CTOPPMemory_Date 2015-02-13            <NA>
    #> 20 TimePoint3          624L CTOPPMemory_Date 2015-02-27            <NA>
    #> 21 TimePoint3          625L CTOPPMemory_Date 2015-02-03            <NA>
    #> 22 TimePoint3          627L CTOPPMemory_Date 2015-02-03            <NA>
    #> 23 TimePoint3          628L CTOPPMemory_Date 2015-04-09            <NA>
    #> 24 TimePoint3          629L CTOPPMemory_Date 2015-05-01            <NA>
    #> 25 TimePoint3          630L CTOPPMemory_Date 2016-01-12            <NA>
    #> 26 TimePoint3          631L CTOPPMemory_Date 2015-06-06            <NA>
    #> 27 TimePoint3          632L CTOPPMemory_Date 2015-04-21            <NA>
    #> 28 TimePoint3          636L CTOPPMemory_Date 2015-05-04            <NA>
    #> 29 TimePoint3          638L CTOPPMemory_Date 2015-06-08            <NA>
    #> 30 TimePoint3          639L CTOPPMemory_Date 2015-05-29            <NA>
    #> 31 TimePoint3          640L CTOPPMemory_Date 2015-05-30            <NA>
    #> 32 TimePoint3          644L CTOPPMemory_Date 2015-08-19            <NA>
    #> 33 TimePoint3          651L CTOPPMemory_Date 2015-10-24            <NA>
    #> 34 TimePoint3          652L CTOPPMemory_Date 2015-07-16            <NA>
    #> 35 TimePoint3          655L CTOPPMemory_Date 2015-12-01            <NA>
    #> 36 TimePoint3          656L CTOPPMemory_Date 2015-07-20            <NA>
    #> 37 TimePoint3          657L CTOPPMemory_Date 2015-09-18            <NA>
    #> 38 TimePoint3          658L CTOPPMemory_Date 2015-08-31            <NA>
    #> 39 TimePoint3          659L CTOPPMemory_Date 2015-09-03            <NA>
    #> 40 TimePoint3          660L CTOPPMemory_Date 2015-10-17            <NA>
    #> 41 TimePoint3          661L CTOPPMemory_Date 2015-10-02            <NA>
    #> 42 TimePoint3          664L CTOPPMemory_Date 2015-10-16            <NA>
    #> 43 TimePoint3          665L CTOPPMemory_Date 2015-10-15            <NA>
    #> 44 TimePoint3          666L CTOPPMemory_Date 2015-09-24            <NA>
    #> 45 TimePoint3          667L CTOPPMemory_Date 2015-10-03            <NA>
    #> 46 TimePoint3          668L CTOPPMemory_Date 2015-09-26            <NA>
    #> 47 TimePoint3          669L CTOPPMemory_Date 2015-10-02            <NA>
    #> 48 TimePoint3          670L CTOPPMemory_Date 2015-09-18            <NA>
    #> 49 TimePoint3          671L CTOPPMemory_Date 2015-11-24            <NA>
    #> 50 TimePoint3          673L CTOPPMemory_Date 2015-11-21            <NA>
    #> 51 TimePoint3          674L CTOPPMemory_Date 2015-11-20            <NA>
    #> 52 TimePoint3          677L CTOPPMemory_Date 2015-12-11            <NA>
    #> 53 TimePoint3          678L CTOPPMemory_Date 2016-01-15            <NA>
    #> 54 TimePoint3          679L CTOPPMemory_Date 2016-03-04            <NA>
    #> 55 TimePoint3          680L CTOPPMemory_Date 2015-12-10            <NA>
    #> 56 TimePoint3          681L CTOPPMemory_Date 2016-02-02            <NA>
    #> 57 TimePoint3          683L CTOPPMemory_Date 2016-02-01            <NA>
    #> 58 TimePoint3          684L CTOPPMemory_Date 2016-01-16            <NA>
    #> 59 TimePoint3          685L CTOPPMemory_Date 2016-02-13            <NA>
    #> 60 TimePoint3          686L CTOPPMemory_Date 2016-02-13            <NA>
    #> 61 TimePoint3          689L CTOPPMemory_Date 2016-02-23            <NA>
    #> 
    #> $DELV_Date
    #>         Study ParticipantID  Variable       DIRT ParticipantInfo
    #> 1        Medu          508M DELV_Date 2015-05-27      2015-05-22
    #> 2        Medu          552M DELV_Date 2015-07-13            <NA>
    #> 3        Medu          553M DELV_Date 2015-07-17            <NA>
    #> 4  TimePoint3          605L DELV_Date 2014-11-18            <NA>
    #> 5  TimePoint3          608L DELV_Date 2015-01-09            <NA>
    #> 6  TimePoint3          609L DELV_Date 2014-12-19            <NA>
    #> 7  TimePoint3          631L DELV_Date 2015-06-20            <NA>
    #> 8  TimePoint3          638L DELV_Date 2015-06-12            <NA>
    #> 9  TimePoint3          660L DELV_Date 2015-11-14            <NA>
    #> 10 TimePoint3          665L DELV_Date 2016-01-07            <NA>
    #> 11 TimePoint3          671L DELV_Date 2015-12-19            <NA>
    #> 12 TimePoint3          677L DELV_Date 2016-01-08            <NA>
    #> 13 TimePoint3          679L DELV_Date 2016-03-05            <NA>
    #> 14 TimePoint3          680L DELV_Date 2016-01-07            <NA>
    #> 15 TimePoint3          681L DELV_Date 2016-02-23            <NA>
    #> 16 TimePoint3          684L DELV_Date 2016-02-27            <NA>
    #> 17 TimePoint3          685L DELV_Date 2016-03-12            <NA>
    #> 18 TimePoint3          686L DELV_Date 2016-03-12            <NA>
    #> 
    #> $EVT_Date
    #>         Study ParticipantID Variable       DIRT ParticipantInfo
    #> 1  CochlearV1          311E EVT_Date 2014-11-09      2013-11-09
    #> 2  CochlearV1          800E EVT_Date 2014-04-07            <NA>
    #> 3  CochlearV1          801E EVT_Date 2014-05-17            <NA>
    #> 4  CochlearV1          802E EVT_Date 2015-03-07            <NA>
    #> 5  CochlearV1          803E EVT_Date 2015-04-19            <NA>
    #> 6  CochlearV1          804E EVT_Date 2015-06-17            <NA>
    #> 7  CochlearV1          805E EVT_Date 2015-04-27            <NA>
    #> 8  CochlearV1          806E EVT_Date 2015-04-02            <NA>
    #> 9  CochlearV1          807E EVT_Date 2015-05-15            <NA>
    #> 10 CochlearV1          808E EVT_Date 2015-07-09            <NA>
    #> 11 CochlearV1          809E EVT_Date 2015-08-15            <NA>
    #> 12 CochlearV2          314E EVT_Date 2016-02-28      2016-02-08
    #> 13 CochlearV2          800E EVT_Date 2015-03-20            <NA>
    #> 14 CochlearV2          801E EVT_Date 2015-05-16            <NA>
    #> 15 LateTalker          250T EVT_Date 2015-10-10            <NA>
    #> 16       Medu          506M EVT_Date 2015-05-18      2015-05-08
    #> 17       Medu          553M EVT_Date 2015-08-03            <NA>
    #> 18       Medu          554M EVT_Date 2015-08-20            <NA>
    #> 19 TimePoint1          016L EVT_Date  2013-1-07      2013-01-07
    #> 20 TimePoint1          600L EVT_Date 2012-10-29            <NA>
    #> 21 TimePoint1          602L EVT_Date 2012-11-27            <NA>
    #> 22 TimePoint1          603L EVT_Date 2012-12-07            <NA>
    #> 23 TimePoint1          604L EVT_Date 2012-11-09            <NA>
    #> 24 TimePoint1          605L EVT_Date 2012-11-12            <NA>
    #> 25 TimePoint1          606L EVT_Date 2013-02-08            <NA>
    #> 26 TimePoint1          607L EVT_Date 2012-11-13            <NA>
    #> 27 TimePoint1          608L EVT_Date 2012-12-06            <NA>
    #> 28 TimePoint1          609L EVT_Date 2012-12-10            <NA>
    #> 29 TimePoint1          610L EVT_Date 2012-11-16            <NA>
    #> 30 TimePoint1          611L EVT_Date 2012-11-19            <NA>
    #> 31 TimePoint1          612L EVT_Date 2012-11-28            <NA>
    #> 32 TimePoint1          613L EVT_Date 2012-11-20            <NA>
    #> 33 TimePoint1          614L EVT_Date 2012-12-17            <NA>
    #> 34 TimePoint1          615L EVT_Date 2012-11-28            <NA>
    #> 35 TimePoint1          616L EVT_Date 2012-12-21            <NA>
    #> 36 TimePoint1          619L EVT_Date 2012-12-14            <NA>
    #> 37 TimePoint1          620L EVT_Date 2012-12-14            <NA>
    #> 38 TimePoint1          622L EVT_Date 2013-01-10            <NA>
    #> 39 TimePoint1          623L EVT_Date 2013-01-11            <NA>
    #> 40 TimePoint1          625L EVT_Date 2013-01-17            <NA>
    #> 41 TimePoint1          626L EVT_Date 2013-01-18            <NA>
    #> 42 TimePoint1          627L EVT_Date 2013-02-28            <NA>
    #> 43 TimePoint1          628L EVT_Date 2013-04-12            <NA>
    #> 44 TimePoint1          629L EVT_Date 2013-05-17            <NA>
    #> 45 TimePoint1          630L EVT_Date 2013-05-17            <NA>
    #> 46 TimePoint1          631L EVT_Date 2013-06-15            <NA>
    #> 47 TimePoint1          632L EVT_Date 2013-06-11            <NA>
    #> 48 TimePoint1          633L EVT_Date 2013-06-03            <NA>
    #> 49 TimePoint1          634L EVT_Date  2013-9-27            <NA>
    #> 50 TimePoint1          636L EVT_Date 2013-06-12            <NA>
    #> 51 TimePoint1          637L EVT_Date 2013-06-13            <NA>
    #> 52 TimePoint1          638L EVT_Date 2013-06-18            <NA>
    #> 53 TimePoint1          639L EVT_Date 2013-06-26            <NA>
    #> 54 TimePoint1          640L EVT_Date 2013-06-29            <NA>
    #> 55 TimePoint1          641L EVT_Date 2013-07-25            <NA>
    #> 56 TimePoint1          642L EVT_Date 2013-08-26            <NA>
    #> 57 TimePoint1          643L EVT_Date 2013-07-09            <NA>
    #> 58 TimePoint1          644L EVT_Date 2013-10-01            <NA>
    #> 59 TimePoint1          645L EVT_Date 2013-07-15            <NA>
    #> 60 TimePoint1          646L EVT_Date 2013-07-22            <NA>
    #> 61 TimePoint1          647L EVT_Date 2013-07-20            <NA>
    #> 62 TimePoint1          651L EVT_Date 2013-09-28            <NA>
    #> 63 TimePoint1          652L EVT_Date 2013-08-28            <NA>
    #> 64 TimePoint1          653L EVT_Date 2013-09-12            <NA>
    #> 65 TimePoint1          654L EVT_Date 2013-09-04            <NA>
    #> 66 TimePoint1          655L EVT_Date 2013-12-10            <NA>
    #> 67 TimePoint1          656L EVT_Date 2013-08-27            <NA>
    #> 68 TimePoint1          657L EVT_Date 2013-09-17            <NA>
    #> 69 TimePoint1          658L EVT_Date 2013-09-12            <NA>
    #> 70 TimePoint1          659L EVT_Date 2013-09-18            <NA>
    #> 71 TimePoint1          660L EVT_Date 2013-09-17            <NA>
    #> 72 TimePoint1          661L EVT_Date 2013-09-19            <NA>
    #> 73 TimePoint1          663L EVT_Date 2013-09-20            <NA>
    #> 74 TimePoint1          664L EVT_Date 2013-10-01            <NA>
    #> 75 TimePoint1          665L EVT_Date 2013-10-21            <NA>
    #> 76 TimePoint1          666L EVT_Date 2013-11-05            <NA>
    #> 77 TimePoint1          667L EVT_Date 2013-10-24            <NA>
    #> 78 TimePoint1          668L EVT_Date 2013-10-23            <NA>
    #> 79 TimePoint1          669L EVT_Date 2013-10-24            <NA>
    #> 80 TimePoint1          670L EVT_Date 2013-11-01            <NA>
    #> 81 TimePoint1          671L EVT_Date 2014-01-04            <NA>
    #> 82 TimePoint1          673L EVT_Date 2013-11-23            <NA>
    #> 83 TimePoint1          674L EVT_Date 2013-12-04            <NA>
    #> 84 TimePoint1          675L EVT_Date 2013-12-12            <NA>
    #> 85 TimePoint1          676L EVT_Date 2014-01-17            <NA>
    #> 86 TimePoint1          677L EVT_Date 2014-01-10            <NA>
    #> 87 TimePoint1          678L EVT_Date 2014-01-11            <NA>
    #> 88 TimePoint1          679L EVT_Date 2014-02-28            <NA>
    #> 89 TimePoint1          680L EVT_Date 2014-01-20            <NA>
    #> 90 TimePoint1          681L EVT_Date 2014-02-24            <NA>
    #> 91 TimePoint1          682L EVT_Date 2014-01-21            <NA>
    #> 92 TimePoint1          683L EVT_Date 2014-02-20            <NA>
    #> 93 TimePoint1          684L EVT_Date 2014-02-15            <NA>
    #> 94 TimePoint1          685L EVT_Date 2014-02-07            <NA>
    #> 95 TimePoint1          686L EVT_Date 2014-03-07            <NA>
    #> 96 TimePoint1          688L EVT_Date 2014-03-15            <NA>
    #> 97 TimePoint1          689L EVT_Date 2014-02-22            <NA>
    #> 
    #> $GFTA_Date
    #>          Study ParticipantID  Variable       DIRT ParticipantInfo
    #> 1   TimePoint1          022L GFTA_Date 2013-05-20      2013-05-22
    #> 2   TimePoint1          075L GFTA_Date 2013-08-28      2013-09-14
    #> 3   TimePoint1          085L GFTA_Date 2013-10-02            <NA>
    #> 4   TimePoint1          110L GFTA_Date 2014-01-24      2014-02-14
    #> 5   TimePoint1          600L GFTA_Date 2012-11-14            <NA>
    #> 6   TimePoint1          602L GFTA_Date 2012-12-11            <NA>
    #> 7   TimePoint1          603L GFTA_Date 2013-01-08            <NA>
    #> 8   TimePoint1          604L GFTA_Date 2012-12-03            <NA>
    #> 9   TimePoint1          605L GFTA_Date 2012-12-04            <NA>
    #> 10  TimePoint1          607L GFTA_Date 2012-11-29            <NA>
    #> 11  TimePoint1          608L GFTA_Date 2012-12-06            <NA>
    #> 12  TimePoint1          609L GFTA_Date 2013-01-07            <NA>
    #> 13  TimePoint1          610L GFTA_Date 2012-12-10            <NA>
    #> 14  TimePoint1          611L GFTA_Date 2013-01-14            <NA>
    #> 15  TimePoint1          612L GFTA_Date 2012-12-05            <NA>
    #> 16  TimePoint1          613L GFTA_Date 2012-12-04            <NA>
    #> 17  TimePoint1          614L GFTA_Date 2012-12-20            <NA>
    #> 18  TimePoint1          615L GFTA_Date 2012-12-12            <NA>
    #> 19  TimePoint1          616L GFTA_Date 2013-02-01            <NA>
    #> 20  TimePoint1          619L GFTA_Date 2013-01-05            <NA>
    #> 21  TimePoint1          620L GFTA_Date 2012-12-20            <NA>
    #> 22  TimePoint1          622L GFTA_Date 2013-03-09            <NA>
    #> 23  TimePoint1          623L GFTA_Date 2013-04-19            <NA>
    #> 24  TimePoint1          624L GFTA_Date  2013-4-11            <NA>
    #> 25  TimePoint1          625L GFTA_Date 2013-04-15            <NA>
    #> 26  TimePoint1          627L GFTA_Date 2013-05-03            <NA>
    #> 27  TimePoint1          628L GFTA_Date 2013-05-08            <NA>
    #> 28  TimePoint1          629L GFTA_Date 2013-05-29            <NA>
    #> 29  TimePoint1          630L GFTA_Date 2013-05-28            <NA>
    #> 30  TimePoint1          631L GFTA_Date 2013-06-15            <NA>
    #> 31  TimePoint1          632L GFTA_Date 2013-06-21            <NA>
    #> 32  TimePoint1          633L GFTA_Date 2013-07-12            <NA>
    #> 33  TimePoint1          636L GFTA_Date 2013-06-26            <NA>
    #> 34  TimePoint1          638L GFTA_Date 2013-06-25            <NA>
    #> 35  TimePoint1          639L GFTA_Date 2013-06-26            <NA>
    #> 36  TimePoint1          640L GFTA_Date 2013-06-29            <NA>
    #> 37  TimePoint1          641L GFTA_Date 2013-08-01            <NA>
    #> 38  TimePoint1          642L GFTA_Date 2013-09-16            <NA>
    #> 39  TimePoint1          643L GFTA_Date 2013-07-16            <NA>
    #> 40  TimePoint1          644L GFTA_Date 2013-10-08            <NA>
    #> 41  TimePoint1          645L GFTA_Date  2013-08-7            <NA>
    #> 42  TimePoint1          646L GFTA_Date  7/22/2013            <NA>
    #> 43  TimePoint1          652L GFTA_Date 2013-09-03            <NA>
    #> 44  TimePoint1          654L GFTA_Date 2013-10-12            <NA>
    #> 45  TimePoint1          655L GFTA_Date 2013-12-10            <NA>
    #> 46  TimePoint1          656L GFTA_Date 2013-09-03            <NA>
    #> 47  TimePoint1          657L GFTA_Date 2013-09-24            <NA>
    #> 48  TimePoint1          658L GFTA_Date 2013-10-03            <NA>
    #> 49  TimePoint1          659L GFTA_Date 2013-09-23            <NA>
    #> 50  TimePoint1          661L GFTA_Date 2013-10-03            <NA>
    #> 51  TimePoint1          664L GFTA_Date 2013-10-22            <NA>
    #> 52  TimePoint1          665L GFTA_Date 2014-01-20            <NA>
    #> 53  TimePoint1          666L GFTA_Date 2013-11-12            <NA>
    #> 54  TimePoint1          668L GFTA_Date 2013-11-06            <NA>
    #> 55  TimePoint1          670L GFTA_Date 2013-11-01            <NA>
    #> 56  TimePoint1          671L GFTA_Date 2014-01-18            <NA>
    #> 57  TimePoint1          673L GFTA_Date 2013-12-14            <NA>
    #> 58  TimePoint1          674L GFTA_Date 2014-01-07            <NA>
    #> 59  TimePoint1          675L GFTA_Date 2013-12-19            <NA>
    #> 60  TimePoint1          676L GFTA_Date 2014-02-06            <NA>
    #> 61  TimePoint1          677L GFTA_Date 2014-01-24            <NA>
    #> 62  TimePoint1          678L GFTA_Date 2014-03-01            <NA>
    #> 63  TimePoint1          679L GFTA_Date 2014-02-28            <NA>
    #> 64  TimePoint1          680L GFTA_Date 2014-01-24            <NA>
    #> 65  TimePoint1          681L GFTA_Date 2014-03-24            <NA>
    #> 66  TimePoint1          682L GFTA_Date 2014-02-25            <NA>
    #> 67  TimePoint1          683L GFTA_Date 2014-02-26            <NA>
    #> 68  TimePoint1          684L GFTA_Date 2014-02-22            <NA>
    #> 69  TimePoint1          685L GFTA_Date 2014-02-14            <NA>
    #> 70  TimePoint1          686L GFTA_Date 2014-03-14            <NA>
    #> 71  TimePoint1          688L GFTA_Date 2014-05-10            <NA>
    #> 72  TimePoint1          689L GFTA_Date 2014-02-27            <NA>
    #> 73  TimePoint3          600L GFTA_Date 2014-12-12            <NA>
    #> 74  TimePoint3          602L GFTA_Date 2014-12-18            <NA>
    #> 75  TimePoint3          604L GFTA_Date 2014-12-23            <NA>
    #> 76  TimePoint3          605L GFTA_Date 2014-11-15            <NA>
    #> 77  TimePoint3          607L GFTA_Date 2014-12-16            <NA>
    #> 78  TimePoint3          608L GFTA_Date 2014-12-30            <NA>
    #> 79  TimePoint3          609L GFTA_Date 2014-12-12            <NA>
    #> 80  TimePoint3          610L GFTA_Date 2014-11-21            <NA>
    #> 81  TimePoint3          611L GFTA_Date 2015-03-27            <NA>
    #> 82  TimePoint3          612L GFTA_Date 2015-01-26            <NA>
    #> 83  TimePoint3          614L GFTA_Date 2015-01-05            <NA>
    #> 84  TimePoint3          615L GFTA_Date 2015-05-21            <NA>
    #> 85  TimePoint3          616L GFTA_Date 2015-02-07            <NA>
    #> 86  TimePoint3          619L GFTA_Date 2015-02-28            <NA>
    #> 87  TimePoint3          620L GFTA_Date 2015-01-23            <NA>
    #> 88  TimePoint3          622L GFTA_Date 2015-03-12            <NA>
    #> 89  TimePoint3          623L GFTA_Date 2015-02-27            <NA>
    #> 90  TimePoint3          624L GFTA_Date 2015-03-06            <NA>
    #> 91  TimePoint3          625L GFTA_Date 2015-03-24            <NA>
    #> 92  TimePoint3          627L GFTA_Date 2015-02-07            <NA>
    #> 93  TimePoint3          628L GFTA_Date 2015-04-30            <NA>
    #> 94  TimePoint3          629L GFTA_Date 2015-05-08            <NA>
    #> 95  TimePoint3          630L GFTA_Date 2016-01-19            <NA>
    #> 96  TimePoint3          631L GFTA_Date 2015-06-13            <NA>
    #> 97  TimePoint3          632L GFTA_Date 2015-05-02            <NA>
    #> 98  TimePoint3          636L GFTA_Date 2015-05-11            <NA>
    #> 99  TimePoint3          638L GFTA_Date 2015-06-10            <NA>
    #> 100 TimePoint3          639L GFTA_Date 2015-06-09            <NA>
    #> 101 TimePoint3          640L GFTA_Date 2015-06-13            <NA>
    #> 102 TimePoint3          644L GFTA_Date 2015-08-21            <NA>
    #> 103 TimePoint3          651L GFTA_Date 2015-11-07            <NA>
    #> 104 TimePoint3          652L GFTA_Date 2015-07-30            <NA>
    #> 105 TimePoint3          655L GFTA_Date 2015-12-18            <NA>
    #> 106 TimePoint3          656L GFTA_Date 2015-07-27            <NA>
    #> 107 TimePoint3          657L GFTA_Date 2015-09-25            <NA>
    #> 108 TimePoint3          658L GFTA_Date 2015-09-01            <NA>
    #> 109 TimePoint3          659L GFTA_Date 2015-09-11            <NA>
    #> 110 TimePoint3          660L GFTA_Date 2015-11-14            <NA>
    #> 111 TimePoint3          661L GFTA_Date 2015-11-06            <NA>
    #> 112 TimePoint3          664L GFTA_Date 2015-11-11            <NA>
    #> 113 TimePoint3          665L GFTA_Date 2015-11-21            <NA>
    #> 114 TimePoint3          666L GFTA_Date 2015-10-08            <NA>
    #> 115 TimePoint3          667L GFTA_Date 2015-10-24            <NA>
    #> 116 TimePoint3          668L GFTA_Date 2015-10-10            <NA>
    #> 117 TimePoint3          669L GFTA_Date 2015-10-09            <NA>
    #> 118 TimePoint3          670L GFTA_Date 2015-09-25            <NA>
    #> 119 TimePoint3          671L GFTA_Date 2015-12-12            <NA>
    #> 120 TimePoint3          673L GFTA_Date 2015-12-19            <NA>
    #> 121 TimePoint3          674L GFTA_Date 2015-12-04            <NA>
    #> 122 TimePoint3          677L GFTA_Date 2016-01-05            <NA>
    #> 123 TimePoint3          678L GFTA_Date 2016-02-19            <NA>
    #> 124 TimePoint3          679L GFTA_Date 2016-03-09            <NA>
    #> 125 TimePoint3          680L GFTA_Date 2015-12-17            <NA>
    #> 126 TimePoint3          681L GFTA_Date 2016-02-09            <NA>
    #> 127 TimePoint3          683L GFTA_Date 2016-02-26            <NA>
    #> 128 TimePoint3          684L GFTA_Date 2016-01-30            <NA>
    #> 129 TimePoint3          685L GFTA_Date 2016-02-20            <NA>
    #> 130 TimePoint3          686L GFTA_Date 2016-02-20            <NA>
    #> 131 TimePoint3          689L GFTA_Date 2016-03-01            <NA>
    #> 
    #> $KBIT_Standard
    #>        Study ParticipantID      Variable DIRT ParticipantInfo
    #> 1 TimePoint3          615L KBIT_Standard  129             124
    #> 
    #> $PPVT_Date
    #>         Study ParticipantID  Variable       DIRT ParticipantInfo
    #> 1  CochlearV1          306E PPVT_Date       <NA>      2014-08-09
    #> 2  CochlearV1          800E PPVT_Date 2014-04-07            <NA>
    #> 3  CochlearV1          801E PPVT_Date 2014-04-26            <NA>
    #> 4  CochlearV1          802E PPVT_Date 2015-03-07            <NA>
    #> 5  CochlearV1          803E PPVT_Date 2015-04-18            <NA>
    #> 6  CochlearV1          804E PPVT_Date 2015-06-17            <NA>
    #> 7  CochlearV1          805E PPVT_Date 2015-04-27            <NA>
    #> 8  CochlearV1          806E PPVT_Date 2015-04-03            <NA>
    #> 9  CochlearV1          807E PPVT_Date 2015-05-15            <NA>
    #> 10 CochlearV1          808E PPVT_Date 2015-07-09            <NA>
    #> 11 CochlearV1          809E PPVT_Date 2015-08-15            <NA>
    #> 12 CochlearV2          800E PPVT_Date 2015-03-20            <NA>
    #> 13 CochlearV2          801E PPVT_Date 2015-05-16            <NA>
    #> 14 LateTalker          250T PPVT_Date 2015-08-22            <NA>
    #> 15       Medu          550M PPVT_Date 2015-07-06            <NA>
    #> 16       Medu          552M PPVT_Date 2015-07-13            <NA>
    #> 17       Medu          553M PPVT_Date 2015-07-17            <NA>
    #> 18       Medu          554M PPVT_Date 2015-08-03            <NA>
    #> 19 TimePoint1          600L PPVT_Date 2012-11-14            <NA>
    #> 20 TimePoint1          602L PPVT_Date 2012-12-18            <NA>
    #> 21 TimePoint1          603L PPVT_Date 2013-01-08            <NA>
    #> 22 TimePoint1          604L PPVT_Date 2012-12-03            <NA>
    #> 23 TimePoint1          605L PPVT_Date 2012-11-27            <NA>
    #> 24 TimePoint1          607L PPVT_Date 2012-11-29            <NA>
    #> 25 TimePoint1          608L PPVT_Date 2012-12-06            <NA>
    #> 26 TimePoint1          609L PPVT_Date 2013-01-07            <NA>
    #> 27 TimePoint1          610L PPVT_Date 2012-12-10            <NA>
    #> 28 TimePoint1          611L PPVT_Date 2013-01-14            <NA>
    #> 29 TimePoint1          612L PPVT_Date 2012-12-05            <NA>
    #> 30 TimePoint1          613L PPVT_Date 2012-12-04            <NA>
    #> 31 TimePoint1          614L PPVT_Date 2012-12-20            <NA>
    #> 32 TimePoint1          615L PPVT_Date 2012-12-12            <NA>
    #> 33 TimePoint1          616L PPVT_Date 2013-02-01            <NA>
    #> 34 TimePoint1          619L PPVT_Date 2013-01-05            <NA>
    #> 35 TimePoint1          620L PPVT_Date 2012-12-20            <NA>
    #> 36 TimePoint1          622L PPVT_Date 2013-03-09            <NA>
    #> 37 TimePoint1          623L PPVT_Date 2013-03-15            <NA>
    #> 38 TimePoint1          625L PPVT_Date 2013-03-12            <NA>
    #> 39 TimePoint1          627L PPVT_Date 2013-04-12            <NA>
    #> 40 TimePoint1          628L PPVT_Date 2013-05-08            <NA>
    #> 41 TimePoint1          629L PPVT_Date 2013-05-17            <NA>
    #> 42 TimePoint1          630L PPVT_Date 2013-05-17            <NA>
    #> 43 TimePoint1          631L PPVT_Date 2013-06-28            <NA>
    #> 44 TimePoint1          632L PPVT_Date 2013-06-21            <NA>
    #> 45 TimePoint1          633L PPVT_Date 2013-06-24            <NA>
    #> 46 TimePoint1          634L PPVT_Date 2013-09-27            <NA>
    #> 47 TimePoint1          635L PPVT_Date 2013-06-17            <NA>
    #> 48 TimePoint1          636L PPVT_Date 2013-06-26            <NA>
    #> 49 TimePoint1          638L PPVT_Date 2013-06-25            <NA>
    #> 50 TimePoint1          639L PPVT_Date 2013-06-26            <NA>
    #> 51 TimePoint1          640L PPVT_Date 2013-07-13            <NA>
    #> 52 TimePoint1          641L PPVT_Date 2013-08-01            <NA>
    #> 53 TimePoint1          642L PPVT_Date 2013-09-16            <NA>
    #> 54 TimePoint1          643L PPVT_Date 2013-07-16            <NA>
    #> 55 TimePoint1          644L PPVT_Date 2013-10-08            <NA>
    #> 56 TimePoint1          645L PPVT_Date 2013-07-19            <NA>
    #> 57 TimePoint1          646L PPVT_Date 2013-07-29            <NA>
    #> 58 TimePoint1          647L PPVT_Date 2013-07-20            <NA>
    #> 59 TimePoint1          649L PPVT_Date 2013-08-14            <NA>
    #> 60 TimePoint1          652L PPVT_Date 2013-09-03            <NA>
    #> 61 TimePoint1          654L PPVT_Date 2013-09-09            <NA>
    #> 62 TimePoint1          655L PPVT_Date 2013-12-10            <NA>
    #> 63 TimePoint1          656L PPVT_Date 2013-09-03            <NA>
    #> 64 TimePoint1          657L PPVT_Date 2013-09-24            <NA>
    #> 65 TimePoint1          658L PPVT_Date 2013-10-03            <NA>
    #> 66 TimePoint1          659L PPVT_Date 2013-09-23            <NA>
    #> 67 TimePoint1          660L PPVT_Date 2013-09-17            <NA>
    #> 68 TimePoint1          661L PPVT_Date 2013-10-03            <NA>
    #> 69 TimePoint1          664L PPVT_Date 2013-10-22            <NA>
    #> 70 TimePoint1          665L PPVT_Date 2013-10-28            <NA>
    #> 71 TimePoint1          666L PPVT_Date 2013-10-22            <NA>
    #> 72 TimePoint1          667L PPVT_Date 2013-10-19            <NA>
    #> 73 TimePoint1          668L PPVT_Date 2013-11-06            <NA>
    #> 74 TimePoint1          669L PPVT_Date 2013-10-29            <NA>
    #> 75 TimePoint1          670L PPVT_Date 2013-11-01            <NA>
    #> 76 TimePoint1          671L PPVT_Date 2014-01-18            <NA>
    #> 77 TimePoint1          673L PPVT_Date 2013-12-14            <NA>
    #> 78 TimePoint1          674L PPVT_Date 2014-01-07            <NA>
    #> 79 TimePoint1          675L PPVT_Date 2013-12-19            <NA>
    #> 80 TimePoint1          676L PPVT_Date 2014-02-06            <NA>
    #> 81 TimePoint1          677L PPVT_Date 2013-12-27            <NA>
    #> 82 TimePoint1          678L PPVT_Date 2014-03-01            <NA>
    #> 83 TimePoint1          679L PPVT_Date 2014-02-28            <NA>
    #> 84 TimePoint1          680L PPVT_Date 2014-01-24            <NA>
    #> 85 TimePoint1          681L PPVT_Date 2014-03-24            <NA>
    #> 86 TimePoint1          682L PPVT_Date 2014-02-25            <NA>
    #> 87 TimePoint1          683L PPVT_Date 2014-02-26            <NA>
    #> 88 TimePoint1          684L PPVT_Date 2014-02-22            <NA>
    #> 89 TimePoint1          685L PPVT_Date 2014-02-07            <NA>
    #> 90 TimePoint1          686L PPVT_Date 2014-03-14            <NA>
    #> 91 TimePoint1          688L PPVT_Date 2014-05-10            <NA>
    #> 92 TimePoint1          689L PPVT_Date 2014-02-27            <NA>
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
