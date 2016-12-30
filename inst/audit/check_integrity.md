Data Integrity Check
================
Tristan Mahr
2016-12-30

In Spring 2016, we had our data-entry team re-enter test scores gathered in our studies, so that we could find data-entry discrepancies. This script compares the original to the re-entered scores.

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

    #> # A tibble: 3 × 4
    #>        Study ParticipantID  DIRT ParticipantInfo
    #>        <chr>         <chr> <lgl>           <lgl>
    #> 1 CochlearV2          312E    NA            TRUE
    #> 2 LateTalker          203T    NA            TRUE
    #> 3 LateTalker          206T    NA            TRUE

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
| CochlearMatching | BRIEFP\_Date                             | TRUE    | :white\_check\_mark: |
| CochlearMatching | CTOPPMemory\_Date                        | TRUE    | :white\_check\_mark: |
| CochlearMatching | CTOPPMemory\_Raw                         | TRUE    | :white\_check\_mark: |
| CochlearMatching | CTOPPMemory\_Scaled                      | TRUE    | :white\_check\_mark: |
| CochlearMatching | EVT\_Date                                | TRUE    | :white\_check\_mark: |
| CochlearMatching | EVT\_Form                                | TRUE    | :white\_check\_mark: |
| CochlearMatching | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| CochlearMatching | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| CochlearMatching | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| CochlearMatching | FruitStroop\_Score                       | TRUE    | :white\_check\_mark: |
| CochlearMatching | GFTA\_Date                               | TRUE    | :white\_check\_mark: |
| CochlearMatching | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| CochlearMatching | PPVT\_Form                               | TRUE    | :white\_check\_mark: |
| CochlearMatching | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| CochlearMatching | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| CochlearMatching | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| CochlearMatching | VerbalFluency\_AgeEquivalent             | TRUE    | :white\_check\_mark: |
| CochlearMatching | VerbalFluency\_Date                      | TRUE    | :white\_check\_mark: |
| CochlearMatching | VerbalFluency\_Score                     | TRUE    | :white\_check\_mark: |
| CochlearV1       | BRIEFP\_Date                             | FALSE   | :x:                  |
| CochlearV1       | CTOPPMemory\_Date                        | TRUE    | :white\_check\_mark: |
| CochlearV1       | CTOPPMemory\_Raw                         | TRUE    | :white\_check\_mark: |
| CochlearV1       | CTOPPMemory\_Scaled                      | TRUE    | :white\_check\_mark: |
| CochlearV1       | EVT\_Date                                | TRUE    | :white\_check\_mark: |
| CochlearV1       | EVT\_Form                                | TRUE    | :white\_check\_mark: |
| CochlearV1       | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| CochlearV1       | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| CochlearV1       | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| CochlearV1       | FruitStroop\_Score                       | TRUE    | :white\_check\_mark: |
| CochlearV1       | GFTA\_Date                               | TRUE    | :white\_check\_mark: |
| CochlearV1       | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| CochlearV1       | PPVT\_Form                               | TRUE    | :white\_check\_mark: |
| CochlearV1       | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| CochlearV1       | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| CochlearV1       | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| CochlearV1       | VerbalFluency\_AgeEquivalent             | TRUE    | :white\_check\_mark: |
| CochlearV1       | VerbalFluency\_Date                      | FALSE   | :x:                  |
| CochlearV1       | VerbalFluency\_Score                     | TRUE    | :white\_check\_mark: |
| CochlearV2       | BRIEFP\_Date                             | TRUE    | :white\_check\_mark: |
| CochlearV2       | CTOPPMemory\_Date                        | TRUE    | :white\_check\_mark: |
| CochlearV2       | CTOPPMemory\_Raw                         | TRUE    | :white\_check\_mark: |
| CochlearV2       | CTOPPMemory\_Scaled                      | TRUE    | :white\_check\_mark: |
| CochlearV2       | EVT\_Date                                | TRUE    | :white\_check\_mark: |
| CochlearV2       | EVT\_Form                                | TRUE    | :white\_check\_mark: |
| CochlearV2       | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| CochlearV2       | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| CochlearV2       | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| CochlearV2       | FruitStroop\_Score                       | TRUE    | :white\_check\_mark: |
| CochlearV2       | GFTA\_Date                               | TRUE    | :white\_check\_mark: |
| CochlearV2       | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| CochlearV2       | PPVT\_Form                               | TRUE    | :white\_check\_mark: |
| CochlearV2       | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| CochlearV2       | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| CochlearV2       | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| CochlearV2       | VerbalFluency\_AgeEquivalent             | TRUE    | :white\_check\_mark: |
| CochlearV2       | VerbalFluency\_Date                      | TRUE    | :white\_check\_mark: |
| CochlearV2       | VerbalFluency\_Score                     | TRUE    | :white\_check\_mark: |
| LateTalker       | BRIEFP\_Date                             | TRUE    | :white\_check\_mark: |
| LateTalker       | CTOPPBlending\_Date                      | TRUE    | :white\_check\_mark: |
| LateTalker       | CTOPPBlending\_Raw                       | TRUE    | :white\_check\_mark: |
| LateTalker       | CTOPPBlending\_Scaled                    | TRUE    | :white\_check\_mark: |
| LateTalker       | CTOPPElision\_Date                       | TRUE    | :white\_check\_mark: |
| LateTalker       | CTOPPElision\_Raw                        | TRUE    | :white\_check\_mark: |
| LateTalker       | CTOPPElision\_Scaled                     | TRUE    | :white\_check\_mark: |
| LateTalker       | CTOPPMemory\_Date                        | TRUE    | :white\_check\_mark: |
| LateTalker       | CTOPPMemory\_Raw                         | TRUE    | :white\_check\_mark: |
| LateTalker       | CTOPPMemory\_Scaled                      | TRUE    | :white\_check\_mark: |
| LateTalker       | DELV\_Date                               | TRUE    | :white\_check\_mark: |
| LateTalker       | DELV\_LanguageRisk                       | TRUE    | :white\_check\_mark: |
| LateTalker       | DELV\_LanguageRisk\_DiagnosticErrorScore | TRUE    | :white\_check\_mark: |
| LateTalker       | DELV\_LanguageVar                        | TRUE    | :white\_check\_mark: |
| LateTalker       | DELV\_LanguageVar\_ColumnAScore          | TRUE    | :white\_check\_mark: |
| LateTalker       | DELV\_LanguageVar\_ColumnBScore          | TRUE    | :white\_check\_mark: |
| LateTalker       | EVT\_Date                                | TRUE    | :white\_check\_mark: |
| LateTalker       | EVT\_Form                                | TRUE    | :white\_check\_mark: |
| LateTalker       | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| LateTalker       | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| LateTalker       | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| LateTalker       | FruitStroop\_Score                       | TRUE    | :white\_check\_mark: |
| LateTalker       | GFTA\_Date                               | FALSE   | :x:                  |
| LateTalker       | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| LateTalker       | PPVT\_Form                               | TRUE    | :white\_check\_mark: |
| LateTalker       | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| LateTalker       | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| LateTalker       | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| LateTalker       | VerbalFluency\_AgeEquivalent             | TRUE    | :white\_check\_mark: |
| LateTalker       | VerbalFluency\_Date                      | FALSE   | :x:                  |
| LateTalker       | VerbalFluency\_Score                     | TRUE    | :white\_check\_mark: |
| Medu             | BRIEFP\_Date                             | FALSE   | :x:                  |
| Medu             | CTOPPBlending\_Date                      | TRUE    | :white\_check\_mark: |
| Medu             | CTOPPBlending\_Raw                       | TRUE    | :white\_check\_mark: |
| Medu             | CTOPPBlending\_Scaled                    | TRUE    | :white\_check\_mark: |
| Medu             | CTOPPElision\_Date                       | FALSE   | :x:                  |
| Medu             | CTOPPElision\_Raw                        | TRUE    | :white\_check\_mark: |
| Medu             | CTOPPElision\_Scaled                     | TRUE    | :white\_check\_mark: |
| Medu             | CTOPPMemory\_Date                        | TRUE    | :white\_check\_mark: |
| Medu             | CTOPPMemory\_Raw                         | TRUE    | :white\_check\_mark: |
| Medu             | CTOPPMemory\_Scaled                      | TRUE    | :white\_check\_mark: |
| Medu             | DELV\_Date                               | FALSE   | :x:                  |
| Medu             | DELV\_LanguageRisk                       | TRUE    | :white\_check\_mark: |
| Medu             | DELV\_LanguageRisk\_DiagnosticErrorScore | TRUE    | :white\_check\_mark: |
| Medu             | DELV\_LanguageVar                        | FALSE   | :x:                  |
| Medu             | DELV\_LanguageVar\_ColumnAScore          | TRUE    | :white\_check\_mark: |
| Medu             | DELV\_LanguageVar\_ColumnBScore          | TRUE    | :white\_check\_mark: |
| Medu             | EVT\_Date                                | TRUE    | :white\_check\_mark: |
| Medu             | EVT\_Form                                | FALSE   | :x:                  |
| Medu             | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| Medu             | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| Medu             | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| Medu             | FruitStroop\_Score                       | TRUE    | :white\_check\_mark: |
| Medu             | GFTA\_Date                               | FALSE   | :x:                  |
| Medu             | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| Medu             | PPVT\_Form                               | TRUE    | :white\_check\_mark: |
| Medu             | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| Medu             | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| Medu             | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| Medu             | VerbalFluency\_AgeEquivalent             | TRUE    | :white\_check\_mark: |
| Medu             | VerbalFluency\_Date                      | FALSE   | :x:                  |
| Medu             | VerbalFluency\_Score                     | TRUE    | :white\_check\_mark: |
| TimePoint1       | BRIEFP\_Date                             | FALSE   | :x:                  |
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
| TimePoint1       | VerbalFluency\_Date                      | FALSE   | :x:                  |
| TimePoint1       | VerbalFluency\_Score                     | TRUE    | :white\_check\_mark: |
| TimePoint2       | CTOPPBlending\_Date                      | FALSE   | :x:                  |
| TimePoint2       | CTOPPBlending\_Raw                       | TRUE    | :white\_check\_mark: |
| TimePoint2       | CTOPPBlending\_Scaled                    | TRUE    | :white\_check\_mark: |
| TimePoint2       | CTOPPElision\_Date                       | FALSE   | :x:                  |
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
| TimePoint2       | VerbalFluency\_Date                      | FALSE   | :x:                  |
| TimePoint2       | VerbalFluency\_Score                     | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPBlending\_Date                      | FALSE   | :x:                  |
| TimePoint3       | CTOPPBlending\_Raw                       | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPBlending\_Scaled                    | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPElision\_Date                       | FALSE   | :x:                  |
| TimePoint3       | CTOPPElision\_Raw                        | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPElision\_Scaled                     | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPMemory\_Date                        | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPMemory\_Raw                         | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPMemory\_Scaled                      | TRUE    | :white\_check\_mark: |
| TimePoint3       | DELV\_Date                               | TRUE    | :white\_check\_mark: |
| TimePoint3       | DELV\_LanguageRisk                       | TRUE    | :white\_check\_mark: |
| TimePoint3       | DELV\_LanguageRisk\_DiagnosticErrorScore | TRUE    | :white\_check\_mark: |
| TimePoint3       | DELV\_LanguageVar                        | FALSE   | :x:                  |
| TimePoint3       | DELV\_LanguageVar\_ColumnAScore          | TRUE    | :white\_check\_mark: |
| TimePoint3       | DELV\_LanguageVar\_ColumnBScore          | TRUE    | :white\_check\_mark: |
| TimePoint3       | EVT\_Date                                | TRUE    | :white\_check\_mark: |
| TimePoint3       | EVT\_Form                                | TRUE    | :white\_check\_mark: |
| TimePoint3       | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| TimePoint3       | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| TimePoint3       | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| TimePoint3       | GFTA\_Date                               | TRUE    | :white\_check\_mark: |
| TimePoint3       | KBIT\_Raw                                | TRUE    | :white\_check\_mark: |
| TimePoint3       | KBIT\_Standard                           | TRUE    | :white\_check\_mark: |
| TimePoint3       | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| TimePoint3       | PPVT\_Form                               | TRUE    | :white\_check\_mark: |
| TimePoint3       | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| TimePoint3       | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| TimePoint3       | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| TimePoint3       | VerbalFluency\_AgeEquivalent             | TRUE    | :white\_check\_mark: |
| TimePoint3       | VerbalFluency\_Date                      | FALSE   | :x:                  |
| TimePoint3       | VerbalFluency\_Score                     | TRUE    | :white\_check\_mark: |

### Details

These are all the mismatching values.

    #> $BRIEFP_Date
    #>         Study ParticipantID    Variable       DIRT ParticipantInfo
    #> 1  CochlearV1          800E BRIEFP_Date 2014-03-24      2014-04-07
    #> 2  CochlearV1          801E BRIEFP_Date 2014-04-26      2014-04-28
    #> 3  CochlearV1          808E BRIEFP_Date 2015-07-10      2015-07-09
    #> 4        Medu          500M BRIEFP_Date 2015-03-16            <NA>
    #> 5        Medu          554M BRIEFP_Date 2015-08-03      2015-10-14
    #> 6  TimePoint1          005L BRIEFP_Date 2012-07-12      2012-12-07
    #> 7  TimePoint1          007L BRIEFP_Date 2012-10-28      2012-11-12
    #> 8  TimePoint1          008L BRIEFP_Date 2012-10-30      2012-11-01
    #> 9  TimePoint1          011L BRIEFP_Date 2013-01-10      2013-01-11
    #> 10 TimePoint1          013L BRIEFP_Date 2013-05-08      2013-05-18
    #> 11 TimePoint1          019L BRIEFP_Date 2013-01-10      2013-02-16
    #> 12 TimePoint1          039L BRIEFP_Date 2013-06-21      2013-06-28
    #> 13 TimePoint1          044L BRIEFP_Date 2014-01-22      2014-02-04
    #> 14 TimePoint1          051L BRIEFP_Date 2013-12-06      2013-12-12
    #> 15 TimePoint1          055L BRIEFP_Date 2013-10-30      2013-11-07
    #> 16 TimePoint1          063L BRIEFP_Date 2013-08-02      2013-07-24
    #> 17 TimePoint1          073L BRIEFP_Date 2013-09-13      2013-09-06
    #> 18 TimePoint1          091L BRIEFP_Date       <NA>      2013-10-19
    #> 19 TimePoint1          101L BRIEFP_Date 2013-10-11      2013-10-03
    #> 20 TimePoint1          110L BRIEFP_Date 2014-01-17      2014-01-07
    #> 21 TimePoint1          115L BRIEFP_Date 2013-12-03      2015-12-03
    #> 22 TimePoint1          125L BRIEFP_Date 2013-12-10      2013-12-18
    #> 23 TimePoint1          128L BRIEFP_Date 2014-01-31      2014-02-07
    #> 24 TimePoint1          619L BRIEFP_Date 2013-05-24      2013-05-12
    #> 25 TimePoint1          627L BRIEFP_Date 2013-03-01      2013-04-12
    #> 26 TimePoint1          635L BRIEFP_Date 2013-06-20      2013-06-17
    #> 27 TimePoint1          642L BRIEFP_Date 2013-08-26      2013-08-20
    #> 28 TimePoint1          650L BRIEFP_Date 2013-08-03      2013-08-10
    #> 29 TimePoint1          655L BRIEFP_Date 2013-12-17      2013-12-18
    #> 30 TimePoint1          656L BRIEFP_Date 2013-08-27      2013-09-02
    #> 31 TimePoint1          659L BRIEFP_Date 2013-09-18      2013-09-13
    #> 32 TimePoint1          670L BRIEFP_Date 2013-10-31      2013-11-01
    #> 33 TimePoint1          671L BRIEFP_Date 2014-01-04      2014-01-18
    #> 34 TimePoint1          678L BRIEFP_Date 2014-01-29      2014-03-01
    #> 35 TimePoint1          679L BRIEFP_Date 2014-02-10      2015-02-13
    #> 36 TimePoint1          681L BRIEFP_Date 3014-03-24      2014-03-24
    #> 37 TimePoint1          685L BRIEFP_Date 2014-02-07      2015-02-14
    #> 38 TimePoint1          686L BRIEFP_Date 2014-03-07      2013-03-07
    #> 39 TimePoint1          688L BRIEFP_Date 2014-03-08      2014-03-14
    #> 
    #> $CTOPPBlending_Date
    #>         Study ParticipantID           Variable       DIRT ParticipantInfo
    #> 1  TimePoint2          078L CTOPPBlending_Date 2015-02-13      2015-02-14
    #> 2  TimePoint2          109L CTOPPBlending_Date 2011-11-18      2014-11-18
    #> 3  TimePoint2          607L CTOPPBlending_Date 2013-12-11           41617
    #> 4  TimePoint3          044L CTOPPBlending_Date 2015-01-15      2016-01-15
    #> 5  TimePoint3          088L CTOPPBlending_Date 2015-09-15      2015-09-25
    #> 6  TimePoint3          089L CTOPPBlending_Date       <NA>      2015-10-03
    #> 7  TimePoint3          623L CTOPPBlending_Date 2015-02-27      2015-02-13
    #> 8  TimePoint3          640L CTOPPBlending_Date 2015-05-30      2015-05-03
    #> 9  TimePoint3          673L CTOPPBlending_Date 2015-11-21      2015-11-02
    #> 10 TimePoint3          678L CTOPPBlending_Date 2015-01-15      2016-01-15
    #> 11 TimePoint3          685L CTOPPBlending_Date 2016-02-13      2016-02-11
    #> 12 TimePoint3          686L CTOPPBlending_Date 2016-02-13      2016-02-11
    #> 
    #> $CTOPPElision_Date
    #>         Study ParticipantID          Variable       DIRT ParticipantInfo
    #> 1        Medu          509M CTOPPElision_Date 2015-06-29      2015-07-08
    #> 2  TimePoint2          078L CTOPPElision_Date 2015-02-13      2015-02-14
    #> 3  TimePoint2          109L CTOPPElision_Date 2011-11-18      2014-11-18
    #> 4  TimePoint2          607L CTOPPElision_Date 2013-12-11           41617
    #> 5  TimePoint3          021L CTOPPElision_Date 2015-03-15      2015-03-14
    #> 6  TimePoint3          089L CTOPPElision_Date       <NA>      2015-10-03
    #> 7  TimePoint3          623L CTOPPElision_Date 2015-02-27      2015-02-13
    #> 8  TimePoint3          640L CTOPPElision_Date 2015-05-30      2015-05-03
    #> 9  TimePoint3          673L CTOPPElision_Date 2015-11-21      2015-11-02
    #> 10 TimePoint3          685L CTOPPElision_Date 2016-02-13      2016-02-11
    #> 11 TimePoint3          686L CTOPPElision_Date 2016-02-13      2016-02-11
    #> 
    #> $DELV_Date
    #>   Study ParticipantID  Variable DIRT ParticipantInfo
    #> 1  Medu          550M DELV_Date <NA>      2015-07-31
    #> 2  Medu          554M DELV_Date <NA>      2015-08-03
    #> 
    #> $DELV_LanguageVar
    #>         Study ParticipantID         Variable DIRT ParticipantInfo
    #> 1        Medu          507M DELV_LanguageVar   NA               0
    #> 2        Medu          508M DELV_LanguageVar   NA               2
    #> 3        Medu          509M DELV_LanguageVar   NA               2
    #> 4        Medu          512M DELV_LanguageVar   NA               2
    #> 5        Medu          552M DELV_LanguageVar   NA               1
    #> 6        Medu          553M DELV_LanguageVar   NA               2
    #> 7  TimePoint3          023L DELV_LanguageVar   NA               1
    #> 8  TimePoint3          024L DELV_LanguageVar   NA               2
    #> 9  TimePoint3          025L DELV_LanguageVar   NA               2
    #> 10 TimePoint3          035L DELV_LanguageVar   NA               2
    #> 11 TimePoint3          036L DELV_LanguageVar   NA               2
    #> 12 TimePoint3          046L DELV_LanguageVar   NA               2
    #> 13 TimePoint3          066L DELV_LanguageVar   NA               2
    #> 
    #> $EVT_Form
    #>   Study ParticipantID Variable DIRT ParticipantInfo
    #> 1  Medu          550M EVT_Form    A            <NA>
    #> 2  Medu          552M EVT_Form    A            <NA>
    #> 
    #> $GFTA_Date
    #>        Study ParticipantID  Variable       DIRT ParticipantInfo
    #> 1 LateTalker          204T GFTA_Date 2015-04-10      2015-04-24
    #> 2       Medu          505M GFTA_Date 2015-05-15      2015-05-19
    #> 3       Medu          506M GFTA_Date 2015-05-01      2015-05-08
    #> 4       Medu          512M GFTA_Date 2015-11-02      2015-11-09
    #> 5 TimePoint1          022L GFTA_Date 2013-05-20      2013-05-22
    #> 6 TimePoint1          075L GFTA_Date 2013-08-28      2013-09-14
    #> 7 TimePoint1          085L GFTA_Date 2013-10-02            <NA>
    #> 8 TimePoint1          110L GFTA_Date 2014-01-24      2014-02-14
    #> 
    #> $VerbalFluency_Date
    #>         Study ParticipantID           Variable       DIRT ParticipantInfo
    #> 1  CochlearV1          310E VerbalFluency_Date 2016-03-10      2016-03-11
    #> 2  CochlearV1          803E VerbalFluency_Date 2015-04-18      2015-04-21
    #> 3  CochlearV1          806E VerbalFluency_Date 2015-04-02            <NA>
    #> 4  CochlearV1          809E VerbalFluency_Date 2015-08-15      2015-08-21
    #> 5  LateTalker          250T VerbalFluency_Date 2015-08-22      2015-08-15
    #> 6        Medu          502M VerbalFluency_Date 2015-05-18      2015-05-08
    #> 7        Medu          511M VerbalFluency_Date       <NA>      2015-08-17
    #> 8        Medu          552M VerbalFluency_Date 2015-07-20      2015-07-24
    #> 9  TimePoint1          002L VerbalFluency_Date 2012-10-17      2012-11-16
    #> 10 TimePoint1          003L VerbalFluency_Date 2012-11-02            <NA>
    #> 11 TimePoint1          004L VerbalFluency_Date 2012-10-22      2012-10-25
    #> 12 TimePoint1          005L VerbalFluency_Date 2012-12-07      2012-12-08
    #> 13 TimePoint1          007L VerbalFluency_Date 2012-10-22      2006-02-02
    #> 14 TimePoint1          008L VerbalFluency_Date 2012-10-22      2006-02-02
    #> 15 TimePoint1          016L VerbalFluency_Date 2013-01-07      2013-01-23
    #> 16 TimePoint1          021L VerbalFluency_Date 2013-03-02      2013-04-19
    #> 17 TimePoint1          026L VerbalFluency_Date 2013-03-18      2013-03-19
    #> 18 TimePoint1          028L VerbalFluency_Date 2013-03-16      2013-03-19
    #> 19 TimePoint1          031L VerbalFluency_Date 2013-04-12      2013-04-26
    #> 20 TimePoint1          041L VerbalFluency_Date 2013-05-18      2013-07-19
    #> 21 TimePoint1          046L VerbalFluency_Date 2013-08-22      2013-08-23
    #> 22 TimePoint1          049L VerbalFluency_Date 2013-08-08      2013-08-13
    #> 23 TimePoint1          062L VerbalFluency_Date 2013-08-12            <NA>
    #> 24 TimePoint1          064L VerbalFluency_Date 2013-07-13      2013-07-19
    #> 25 TimePoint1          068L VerbalFluency_Date 2013-07-18      2013-08-02
    #> 26 TimePoint1          069L VerbalFluency_Date 2013-08-03      2013-08-07
    #> 27 TimePoint1          077L VerbalFluency_Date 2013-08-24      2013-08-30
    #> 28 TimePoint1          089L VerbalFluency_Date 2013-09-13      2013-09-20
    #> 29 TimePoint1          091L VerbalFluency_Date 2013-10-19            <NA>
    #> 30 TimePoint1          101L VerbalFluency_Date 2013-10-03      2013-10-18
    #> 31 TimePoint1          108L VerbalFluency_Date 2013-12-07      2013-12-08
    #> 32 TimePoint1          116L VerbalFluency_Date 2013-11-26      2013-11-27
    #> 33 TimePoint1          119L VerbalFluency_Date 2014-01-20      2015-07-20
    #> 34 TimePoint1          602L VerbalFluency_Date 2012-12-11      2012-12-18
    #> 35 TimePoint1          619L VerbalFluency_Date 2013-05-24      2013-07-08
    #> 36 TimePoint1          624L VerbalFluency_Date 2013-04-10            <NA>
    #> 37 TimePoint1          632L VerbalFluency_Date 2013-06-21            <NA>
    #> 38 TimePoint1          633L VerbalFluency_Date 2013-06-24            <NA>
    #> 39 TimePoint1          635L VerbalFluency_Date 2013-06-20            <NA>
    #> 40 TimePoint1          636L VerbalFluency_Date 2013-06-19      2013-10-09
    #> 41 TimePoint1          639L VerbalFluency_Date 2013-07-24      2013-10-09
    #> 42 TimePoint1          646L VerbalFluency_Date 2013-07-29            <NA>
    #> 43 TimePoint1          649L VerbalFluency_Date 2013-08-21            <NA>
    #> 44 TimePoint1          652L VerbalFluency_Date 2013-09-03      2014-02-04
    #> 45 TimePoint1          664L VerbalFluency_Date 2013-10-22            <NA>
    #> 46 TimePoint1          665L VerbalFluency_Date 2013-10-28            <NA>
    #> 47 TimePoint1          667L VerbalFluency_Date 2013-10-24            <NA>
    #> 48 TimePoint1          670L VerbalFluency_Date 2013-11-25      2015-08-18
    #> 49 TimePoint1          671L VerbalFluency_Date 2014-01-18      2015-08-18
    #> 50 TimePoint1          674L VerbalFluency_Date 2014-01-07            <NA>
    #> 51 TimePoint1          678L VerbalFluency_Date 2014-03-01            <NA>
    #> 52 TimePoint1          680L VerbalFluency_Date 2014-01-24      2006-07-30
    #> 53 TimePoint1          682L VerbalFluency_Date 2014-02-25            <NA>
    #> 54 TimePoint2          004L VerbalFluency_Date 2013-11-11      2013-11-13
    #> 55 TimePoint2          005L VerbalFluency_Date  2013-11-7      2013-11-07
    #> 56 TimePoint2          008L VerbalFluency_Date 2013-11-21      2013-11-22
    #> 57 TimePoint2          076L VerbalFluency_Date 2014-01-26      2015-01-26
    #> 58 TimePoint2          078L VerbalFluency_Date 2015-02-13      2015-02-14
    #> 59 TimePoint2          106L VerbalFluency_Date 2014-12-01      2014-12-02
    #> 60 TimePoint2          600L VerbalFluency_Date 2013-11-20            <NA>
    #> 61 TimePoint2          602L VerbalFluency_Date 2013-11-26            <NA>
    #> 62 TimePoint2          603L VerbalFluency_Date 2013-12-13            <NA>
    #> 63 TimePoint2          604L VerbalFluency_Date 2014-01-15            <NA>
    #> 64 TimePoint2          605L VerbalFluency_Date 2013-12-02            <NA>
    #> 65 TimePoint2          607L VerbalFluency_Date 2013-12-16            <NA>
    #> 66 TimePoint2          609L VerbalFluency_Date 2013-12-10            <NA>
    #> 67 TimePoint2          610L VerbalFluency_Date 2013-12-06            <NA>
    #> 68 TimePoint2          612L VerbalFluency_Date 2014-01-13            <NA>
    #> 69 TimePoint2          613L VerbalFluency_Date 2014-01-13            <NA>
    #> 70 TimePoint2          615L VerbalFluency_Date 2014-01-30            <NA>
    #> 71 TimePoint2          616L VerbalFluency_Date 2014-02-04            <NA>
    #> 72 TimePoint2          619L VerbalFluency_Date 2014-02-01            <NA>
    #> 73 TimePoint2          620L VerbalFluency_Date 2014-01-22            <NA>
    #> 74 TimePoint2          622L VerbalFluency_Date 2014-02-08            <NA>
    #> 75 TimePoint2          624L VerbalFluency_Date 2014-02-07            <NA>
    #> 76 TimePoint2          638L VerbalFluency_Date 2014-06-20      2015-07-21
    #> 77 TimePoint2          665L VerbalFluency_Date 2014-10-10      2015-08-18
    #> 78 TimePoint2          666L VerbalFluency_Date 2014-10-10      2015-08-18
    #> 79 TimePoint2          669L VerbalFluency_Date 2014-10-17            <NA>
    #> 80 TimePoint2          670L VerbalFluency_Date 2014-09-30      2015-08-18
    #> 81 TimePoint2          679L VerbalFluency_Date 2015-03-09            <NA>
    #> 82 TimePoint3          014L VerbalFluency_Date 2015-02-18      2015-02-19
    #> 83 TimePoint3          068L VerbalFluency_Date 2015-06-25            <NA>
    #> 84 TimePoint3          078L VerbalFluency_Date 2016-01-22      2016-01-23
    #> 85 TimePoint3          097L VerbalFluency_Date 2015-12-05            <NA>
    #> 86 TimePoint3          099L VerbalFluency_Date 2015-12-05      2015-12-06
    #> 87 TimePoint3          100L VerbalFluency_Date 2015-11-11      2015-11-12
    #> 88 TimePoint3          101L VerbalFluency_Date 2015-11-11      2015-11-12
    #> 89 TimePoint3          129L VerbalFluency_Date 2016-03-06            <NA>
    #> 90 TimePoint3          604L VerbalFluency_Date 2014-12-23      2015-07-21
    #> 91 TimePoint3          610L VerbalFluency_Date 2014-11-07            <NA>
    #> 92 TimePoint3          652L VerbalFluency_Date 2015-07-30            <NA>
    #> 93 TimePoint3          656L VerbalFluency_Date 2015-07-27            <NA>
    #> 94 TimePoint3          666L VerbalFluency_Date 2015-10-08            <NA>
    #> 95 TimePoint3          671L VerbalFluency_Date 2015-12-12      2016-01-06

### Unchecked fields

The following columns in DIRT were not checked because there is not a matching column in the participant info spreadsheets

| Study            | Variable                |                  |
|:-----------------|:------------------------|------------------|
| Medu             | DELV\_DegreeLanguageVar | :grey\_question: |
| TimePoint1       | FruitStroop\_Date       | :grey\_question: |
| TimePoint1       | MBCDI\_Date             | :grey\_question: |
| TimePoint1       | CDI\_Extension\_Date    | :grey\_question: |
| TimePoint2       | FruitStroop\_Date       | :grey\_question: |
| TimePoint2       | KBIT\_Date              | :grey\_question: |
| TimePoint3       | KBIT\_Date              | :grey\_question: |
| TimePoint3       | DELV\_DegreeLanguageVar | :grey\_question: |
| LateTalker       | MBCDI\_Date             | :grey\_question: |
| LateTalker       | CDI\_Extension\_Date    | :grey\_question: |
| LateTalker       | FruitStroop\_Date       | :grey\_question: |
| LateTalker       | DELV\_DegreeLanguageVar | :grey\_question: |
| CochlearV1       | CDI\_Extension\_Date    | :grey\_question: |
| CochlearV1       | MBCDI\_Date             | :grey\_question: |
| CochlearV1       | FruitStroop\_Date       | :grey\_question: |
| CochlearV1       | CDI W&G                 | :grey\_question: |
| CochlearV2       | MBCDI\_Date             | :grey\_question: |
| CochlearV2       | CDI\_Extension\_Date    | :grey\_question: |
| CochlearV2       | FruitStroop\_Date       | :grey\_question: |
| CochlearMatching | CDI\_Extension\_Date    | :grey\_question: |
| CochlearMatching | MBCDI\_Date             | :grey\_question: |
| CochlearMatching | FruitStroop\_Date       | :grey\_question: |
| Medu             | FruitStroop\_Date       | :grey\_question: |
| Medu             | MBCDI\_Date             | :grey\_question: |
| Medu             | CDI\_Extension\_Date    | :grey\_question: |
