Data Integrity Check
================
Tristan Mahr
2017-01-13

In Spring 2016, we had our data-entry team re-enter test scores gathered in our studies, so that we could find data-entry discrepancies. This script compares the original to the re-entered scores.

Studies under consideration
---------------------------

Data from the following studies are checked:

    #> [1] "TimePoint1"       "TimePoint2"       "TimePoint3"      
    #> [4] "CochlearV1"       "CochlearV2"       "CochlearMatching"
    #> [7] "LateTalker"       "MaternalEd"       "Dialect"

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
| CochlearMatching | FruitStroop\_Date                        | TRUE    | :white\_check\_mark: |
| CochlearMatching | GFTA\_Date                               | TRUE    | :white\_check\_mark: |
| CochlearMatching | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| CochlearMatching | PPVT\_Form                               | TRUE    | :white\_check\_mark: |
| CochlearMatching | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| CochlearMatching | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| CochlearMatching | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| CochlearMatching | VerbalFluency\_Date                      | TRUE    | :white\_check\_mark: |
| CochlearV1       | BRIEFP\_Date                             | TRUE    | :white\_check\_mark: |
| CochlearV1       | CTOPPMemory\_Date                        | TRUE    | :white\_check\_mark: |
| CochlearV1       | CTOPPMemory\_Raw                         | TRUE    | :white\_check\_mark: |
| CochlearV1       | CTOPPMemory\_Scaled                      | TRUE    | :white\_check\_mark: |
| CochlearV1       | EVT\_Date                                | TRUE    | :white\_check\_mark: |
| CochlearV1       | EVT\_Form                                | TRUE    | :white\_check\_mark: |
| CochlearV1       | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| CochlearV1       | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| CochlearV1       | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| CochlearV1       | FruitStroop\_Date                        | TRUE    | :white\_check\_mark: |
| CochlearV1       | GFTA\_Date                               | TRUE    | :white\_check\_mark: |
| CochlearV1       | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| CochlearV1       | PPVT\_Form                               | TRUE    | :white\_check\_mark: |
| CochlearV1       | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| CochlearV1       | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| CochlearV1       | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| CochlearV1       | VerbalFluency\_Date                      | TRUE    | :white\_check\_mark: |
| CochlearV2       | BRIEFP\_Date                             | TRUE    | :white\_check\_mark: |
| CochlearV2       | CTOPPMemory\_Date                        | TRUE    | :white\_check\_mark: |
| CochlearV2       | CTOPPMemory\_Raw                         | TRUE    | :white\_check\_mark: |
| CochlearV2       | CTOPPMemory\_Scaled                      | TRUE    | :white\_check\_mark: |
| CochlearV2       | EVT\_Date                                | TRUE    | :white\_check\_mark: |
| CochlearV2       | EVT\_Form                                | TRUE    | :white\_check\_mark: |
| CochlearV2       | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| CochlearV2       | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| CochlearV2       | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| CochlearV2       | FruitStroop\_Date                        | TRUE    | :white\_check\_mark: |
| CochlearV2       | GFTA\_Date                               | TRUE    | :white\_check\_mark: |
| CochlearV2       | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| CochlearV2       | PPVT\_Form                               | TRUE    | :white\_check\_mark: |
| CochlearV2       | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| CochlearV2       | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| CochlearV2       | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| CochlearV2       | VerbalFluency\_Date                      | TRUE    | :white\_check\_mark: |
| Dialect          | BRIEFP\_Date                             | FALSE   | :x:                  |
| Dialect          | EVT\_Date                                | FALSE   | :x:                  |
| Dialect          | EVT\_Form                                | TRUE    | :white\_check\_mark: |
| Dialect          | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| Dialect          | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| Dialect          | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| Dialect          | FruitStroop\_Date                        | TRUE    | :white\_check\_mark: |
| Dialect          | GFTA\_Date                               | TRUE    | :white\_check\_mark: |
| Dialect          | PPVT\_Date                               | FALSE   | :x:                  |
| Dialect          | PPVT\_Form                               | TRUE    | :white\_check\_mark: |
| Dialect          | PPVT\_GSV                                | FALSE   | :x:                  |
| Dialect          | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| Dialect          | PPVT\_Standard                           | FALSE   | :x:                  |
| Dialect          | VerbalFluency\_Date                      | TRUE    | :white\_check\_mark: |
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
| LateTalker       | DELV\_DegreeLanguageVar                  | TRUE    | :white\_check\_mark: |
| LateTalker       | DELV\_LanguageRisk                       | TRUE    | :white\_check\_mark: |
| LateTalker       | DELV\_LanguageRisk\_DiagnosticErrorScore | TRUE    | :white\_check\_mark: |
| LateTalker       | DELV\_LanguageVar\_ColumnAScore          | TRUE    | :white\_check\_mark: |
| LateTalker       | DELV\_LanguageVar\_ColumnBScore          | TRUE    | :white\_check\_mark: |
| LateTalker       | EVT\_Date                                | TRUE    | :white\_check\_mark: |
| LateTalker       | EVT\_Form                                | TRUE    | :white\_check\_mark: |
| LateTalker       | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| LateTalker       | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| LateTalker       | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| LateTalker       | FruitStroop\_Date                        | TRUE    | :white\_check\_mark: |
| LateTalker       | GFTA\_Date                               | TRUE    | :white\_check\_mark: |
| LateTalker       | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| LateTalker       | PPVT\_Form                               | TRUE    | :white\_check\_mark: |
| LateTalker       | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| LateTalker       | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| LateTalker       | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| LateTalker       | VerbalFluency\_Date                      | TRUE    | :white\_check\_mark: |
| MaternalEd       | BRIEFP\_Date                             | TRUE    | :white\_check\_mark: |
| MaternalEd       | CTOPPBlending\_Date                      | TRUE    | :white\_check\_mark: |
| MaternalEd       | CTOPPBlending\_Raw                       | TRUE    | :white\_check\_mark: |
| MaternalEd       | CTOPPBlending\_Scaled                    | TRUE    | :white\_check\_mark: |
| MaternalEd       | CTOPPElision\_Date                       | TRUE    | :white\_check\_mark: |
| MaternalEd       | CTOPPElision\_Raw                        | TRUE    | :white\_check\_mark: |
| MaternalEd       | CTOPPElision\_Scaled                     | TRUE    | :white\_check\_mark: |
| MaternalEd       | CTOPPMemory\_Date                        | TRUE    | :white\_check\_mark: |
| MaternalEd       | CTOPPMemory\_Raw                         | TRUE    | :white\_check\_mark: |
| MaternalEd       | CTOPPMemory\_Scaled                      | TRUE    | :white\_check\_mark: |
| MaternalEd       | DELV\_Date                               | TRUE    | :white\_check\_mark: |
| MaternalEd       | DELV\_DegreeLanguageVar                  | TRUE    | :white\_check\_mark: |
| MaternalEd       | DELV\_LanguageRisk                       | TRUE    | :white\_check\_mark: |
| MaternalEd       | DELV\_LanguageRisk\_DiagnosticErrorScore | TRUE    | :white\_check\_mark: |
| MaternalEd       | DELV\_LanguageVar\_ColumnAScore          | TRUE    | :white\_check\_mark: |
| MaternalEd       | DELV\_LanguageVar\_ColumnBScore          | TRUE    | :white\_check\_mark: |
| MaternalEd       | EVT\_Date                                | TRUE    | :white\_check\_mark: |
| MaternalEd       | EVT\_Form                                | TRUE    | :white\_check\_mark: |
| MaternalEd       | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| MaternalEd       | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| MaternalEd       | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| MaternalEd       | FruitStroop\_Date                        | TRUE    | :white\_check\_mark: |
| MaternalEd       | GFTA\_Date                               | TRUE    | :white\_check\_mark: |
| MaternalEd       | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| MaternalEd       | PPVT\_Form                               | TRUE    | :white\_check\_mark: |
| MaternalEd       | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| MaternalEd       | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| MaternalEd       | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| MaternalEd       | VerbalFluency\_Date                      | TRUE    | :white\_check\_mark: |
| TimePoint1       | BRIEFP\_Date                             | TRUE    | :white\_check\_mark: |
| TimePoint1       | EVT\_Date                                | TRUE    | :white\_check\_mark: |
| TimePoint1       | EVT\_Form                                | TRUE    | :white\_check\_mark: |
| TimePoint1       | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| TimePoint1       | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| TimePoint1       | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| TimePoint1       | FruitStroop\_Date                        | TRUE    | :white\_check\_mark: |
| TimePoint1       | GFTA\_Date                               | TRUE    | :white\_check\_mark: |
| TimePoint1       | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| TimePoint1       | PPVT\_Form                               | TRUE    | :white\_check\_mark: |
| TimePoint1       | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| TimePoint1       | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| TimePoint1       | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| TimePoint1       | VerbalFluency\_Date                      | TRUE    | :white\_check\_mark: |
| TimePoint2       | CTOPPBlending\_Date                      | TRUE    | :white\_check\_mark: |
| TimePoint2       | CTOPPBlending\_Raw                       | TRUE    | :white\_check\_mark: |
| TimePoint2       | CTOPPBlending\_Scaled                    | TRUE    | :white\_check\_mark: |
| TimePoint2       | CTOPPElision\_Date                       | TRUE    | :white\_check\_mark: |
| TimePoint2       | CTOPPElision\_Raw                        | TRUE    | :white\_check\_mark: |
| TimePoint2       | CTOPPElision\_Scaled                     | TRUE    | :white\_check\_mark: |
| TimePoint2       | EVT\_Date                                | TRUE    | :white\_check\_mark: |
| TimePoint2       | EVT\_Form                                | TRUE    | :white\_check\_mark: |
| TimePoint2       | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| TimePoint2       | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| TimePoint2       | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| TimePoint2       | FruitStroop\_Date                        | TRUE    | :white\_check\_mark: |
| TimePoint2       | KBIT\_Raw                                | TRUE    | :white\_check\_mark: |
| TimePoint2       | KBIT\_Standard                           | TRUE    | :white\_check\_mark: |
| TimePoint2       | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| TimePoint2       | PPVT\_Form                               | TRUE    | :white\_check\_mark: |
| TimePoint2       | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| TimePoint2       | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| TimePoint2       | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| TimePoint2       | VerbalFluency\_Date                      | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPBlending\_Date                      | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPBlending\_Raw                       | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPBlending\_Scaled                    | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPElision\_Date                       | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPElision\_Raw                        | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPElision\_Scaled                     | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPMemory\_Date                        | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPMemory\_Raw                         | TRUE    | :white\_check\_mark: |
| TimePoint3       | CTOPPMemory\_Scaled                      | TRUE    | :white\_check\_mark: |
| TimePoint3       | DELV\_Date                               | TRUE    | :white\_check\_mark: |
| TimePoint3       | DELV\_DegreeLanguageVar                  | TRUE    | :white\_check\_mark: |
| TimePoint3       | DELV\_LanguageRisk                       | TRUE    | :white\_check\_mark: |
| TimePoint3       | DELV\_LanguageRisk\_DiagnosticErrorScore | TRUE    | :white\_check\_mark: |
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
| TimePoint3       | VerbalFluency\_Date                      | TRUE    | :white\_check\_mark: |

### Details

These are all the mismatching values.

    #> $BRIEFP_Date
    #>     Study ParticipantID    Variable       DIRT ParticipantInfo
    #> 1 Dialect          429D BRIEFP_Date 2014-03-22      2014-03-29
    #> 2 Dialect          442D BRIEFP_Date 2014-05-30      2014-06-13
    #> 
    #> $EVT_Date
    #>     Study ParticipantID Variable       DIRT ParticipantInfo
    #> 1 Dialect          405D EVT_Date 2013-10-01      2010-01-13
    #> 2 Dialect          450D EVT_Date 2014-06-29      2014-06-19
    #> 
    #> $PPVT_Date
    #>     Study ParticipantID  Variable       DIRT ParticipantInfo
    #> 1 Dialect          421D PPVT_Date 2013-11-09      2013-11-04
    #> 2 Dialect          459D PPVT_Date 2014-09-27      2011-05-07
    #> 
    #> $PPVT_GSV
    #>     Study ParticipantID Variable DIRT ParticipantInfo
    #> 1 Dialect          422D PPVT_GSV  126             125
    #> 
    #> $PPVT_Standard
    #>     Study ParticipantID      Variable DIRT ParticipantInfo
    #> 1 Dialect          402D PPVT_Standard  100             108

### Unchecked fields

The following columns in DIRT were not checked because there is not a matching column in the participant info spreadsheets

| Study            | Variable                     |                  |
|:-----------------|:-----------------------------|------------------|
| MaternalEd       | VerbalFluency\_Score         | :grey\_question: |
| MaternalEd       | VerbalFluency\_AgeEquivalent | :grey\_question: |
| MaternalEd       | MBCDI\_Date                  | :grey\_question: |
| MaternalEd       | FruitStroop\_Score           | :grey\_question: |
| MaternalEd       | CDI\_Extension\_Date         | :grey\_question: |
| TimePoint1       | VerbalFluency\_Score         | :grey\_question: |
| TimePoint1       | VerbalFluency\_AgeEquivalent | :grey\_question: |
| TimePoint1       | MBCDI\_Date                  | :grey\_question: |
| TimePoint1       | FruitStroop\_Score           | :grey\_question: |
| TimePoint1       | CDI\_Extension\_Date         | :grey\_question: |
| TimePoint2       | VerbalFluency\_Score         | :grey\_question: |
| TimePoint2       | FruitStroop\_Score           | :grey\_question: |
| TimePoint2       | VerbalFluency\_AgeEquivalent | :grey\_question: |
| TimePoint2       | KBIT\_Date                   | :grey\_question: |
| TimePoint3       | VerbalFluency\_Score         | :grey\_question: |
| TimePoint3       | VerbalFluency\_AgeEquivalent | :grey\_question: |
| TimePoint3       | KBIT\_Date                   | :grey\_question: |
| LateTalker       | MBCDI\_Date                  | :grey\_question: |
| LateTalker       | CDI\_Extension\_Date         | :grey\_question: |
| LateTalker       | VerbalFluency\_Score         | :grey\_question: |
| LateTalker       | VerbalFluency\_AgeEquivalent | :grey\_question: |
| LateTalker       | FruitStroop\_Score           | :grey\_question: |
| CochlearV1       | CDI\_Extension\_Date         | :grey\_question: |
| CochlearV1       | MBCDI\_Date                  | :grey\_question: |
| CochlearV1       | VerbalFluency\_AgeEquivalent | :grey\_question: |
| CochlearV1       | VerbalFluency\_Score         | :grey\_question: |
| CochlearV1       | FruitStroop\_Score           | :grey\_question: |
| CochlearV1       | CDI W&G                      | :grey\_question: |
| CochlearV2       | MBCDI\_Date                  | :grey\_question: |
| CochlearV2       | CDI\_Extension\_Date         | :grey\_question: |
| CochlearV2       | FruitStroop\_Score           | :grey\_question: |
| CochlearV2       | VerbalFluency\_Score         | :grey\_question: |
| CochlearV2       | VerbalFluency\_AgeEquivalent | :grey\_question: |
| CochlearMatching | CDI\_Extension\_Date         | :grey\_question: |
| CochlearMatching | MBCDI\_Date                  | :grey\_question: |
| CochlearMatching | FruitStroop\_Score           | :grey\_question: |
| CochlearMatching | VerbalFluency\_AgeEquivalent | :grey\_question: |
| CochlearMatching | VerbalFluency\_Score         | :grey\_question: |
| Dialect          | VerbalFluency\_Score         | :grey\_question: |
| Dialect          | VerbalFluency\_AgeEquivalent | :grey\_question: |
| Dialect          | FruitStroop\_Score           | :grey\_question: |
