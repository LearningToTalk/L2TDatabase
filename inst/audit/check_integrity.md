Data Integrity Check
================
Tristan Mahr
2017-01-03

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
| CochlearV1       | BRIEFP\_Date                             | TRUE    | :white\_check\_mark: |
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
| CochlearV1       | VerbalFluency\_Date                      | TRUE    | :white\_check\_mark: |
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
| LateTalker       | FruitStroop\_Score                       | TRUE    | :white\_check\_mark: |
| LateTalker       | GFTA\_Date                               | TRUE    | :white\_check\_mark: |
| LateTalker       | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| LateTalker       | PPVT\_Form                               | TRUE    | :white\_check\_mark: |
| LateTalker       | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| LateTalker       | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| LateTalker       | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| LateTalker       | VerbalFluency\_AgeEquivalent             | TRUE    | :white\_check\_mark: |
| LateTalker       | VerbalFluency\_Date                      | TRUE    | :white\_check\_mark: |
| LateTalker       | VerbalFluency\_Score                     | TRUE    | :white\_check\_mark: |
| Medu             | BRIEFP\_Date                             | TRUE    | :white\_check\_mark: |
| Medu             | CTOPPBlending\_Date                      | TRUE    | :white\_check\_mark: |
| Medu             | CTOPPBlending\_Raw                       | TRUE    | :white\_check\_mark: |
| Medu             | CTOPPBlending\_Scaled                    | TRUE    | :white\_check\_mark: |
| Medu             | CTOPPElision\_Date                       | TRUE    | :white\_check\_mark: |
| Medu             | CTOPPElision\_Raw                        | TRUE    | :white\_check\_mark: |
| Medu             | CTOPPElision\_Scaled                     | TRUE    | :white\_check\_mark: |
| Medu             | CTOPPMemory\_Date                        | TRUE    | :white\_check\_mark: |
| Medu             | CTOPPMemory\_Raw                         | TRUE    | :white\_check\_mark: |
| Medu             | CTOPPMemory\_Scaled                      | TRUE    | :white\_check\_mark: |
| Medu             | DELV\_Date                               | TRUE    | :white\_check\_mark: |
| Medu             | DELV\_DegreeLanguageVar                  | TRUE    | :white\_check\_mark: |
| Medu             | DELV\_LanguageRisk                       | TRUE    | :white\_check\_mark: |
| Medu             | DELV\_LanguageRisk\_DiagnosticErrorScore | TRUE    | :white\_check\_mark: |
| Medu             | DELV\_LanguageVar\_ColumnAScore          | TRUE    | :white\_check\_mark: |
| Medu             | DELV\_LanguageVar\_ColumnBScore          | TRUE    | :white\_check\_mark: |
| Medu             | EVT\_Date                                | TRUE    | :white\_check\_mark: |
| Medu             | EVT\_Form                                | TRUE    | :white\_check\_mark: |
| Medu             | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| Medu             | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| Medu             | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| Medu             | FruitStroop\_Score                       | TRUE    | :white\_check\_mark: |
| Medu             | GFTA\_Date                               | TRUE    | :white\_check\_mark: |
| Medu             | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| Medu             | PPVT\_Form                               | TRUE    | :white\_check\_mark: |
| Medu             | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| Medu             | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| Medu             | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| Medu             | VerbalFluency\_AgeEquivalent             | TRUE    | :white\_check\_mark: |
| Medu             | VerbalFluency\_Date                      | TRUE    | :white\_check\_mark: |
| Medu             | VerbalFluency\_Score                     | TRUE    | :white\_check\_mark: |
| TimePoint1       | BRIEFP\_Date                             | TRUE    | :white\_check\_mark: |
| TimePoint1       | EVT\_Date                                | TRUE    | :white\_check\_mark: |
| TimePoint1       | EVT\_Form                                | TRUE    | :white\_check\_mark: |
| TimePoint1       | EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| TimePoint1       | EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| TimePoint1       | EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| TimePoint1       | FruitStroop\_Score                       | TRUE    | :white\_check\_mark: |
| TimePoint1       | GFTA\_Date                               | TRUE    | :white\_check\_mark: |
| TimePoint1       | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| TimePoint1       | PPVT\_Form                               | TRUE    | :white\_check\_mark: |
| TimePoint1       | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| TimePoint1       | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| TimePoint1       | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| TimePoint1       | VerbalFluency\_AgeEquivalent             | TRUE    | :white\_check\_mark: |
| TimePoint1       | VerbalFluency\_Date                      | TRUE    | :white\_check\_mark: |
| TimePoint1       | VerbalFluency\_Score                     | TRUE    | :white\_check\_mark: |
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
| TimePoint2       | FruitStroop\_Score                       | TRUE    | :white\_check\_mark: |
| TimePoint2       | KBIT\_Raw                                | TRUE    | :white\_check\_mark: |
| TimePoint2       | KBIT\_Standard                           | TRUE    | :white\_check\_mark: |
| TimePoint2       | PPVT\_Date                               | TRUE    | :white\_check\_mark: |
| TimePoint2       | PPVT\_Form                               | TRUE    | :white\_check\_mark: |
| TimePoint2       | PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| TimePoint2       | PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| TimePoint2       | PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| TimePoint2       | VerbalFluency\_AgeEquivalent             | TRUE    | :white\_check\_mark: |
| TimePoint2       | VerbalFluency\_Date                      | TRUE    | :white\_check\_mark: |
| TimePoint2       | VerbalFluency\_Score                     | TRUE    | :white\_check\_mark: |
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
| TimePoint3       | VerbalFluency\_AgeEquivalent             | TRUE    | :white\_check\_mark: |
| TimePoint3       | VerbalFluency\_Date                      | TRUE    | :white\_check\_mark: |
| TimePoint3       | VerbalFluency\_Score                     | TRUE    | :white\_check\_mark: |

### Details

These are all the mismatching values.

    #> named list()

### Unchecked fields

The following columns in DIRT were not checked because there is not a matching column in the participant info spreadsheets

| Study            | Variable             |                  |
|:-----------------|:---------------------|------------------|
| TimePoint1       | FruitStroop\_Date    | :grey\_question: |
| TimePoint1       | MBCDI\_Date          | :grey\_question: |
| TimePoint1       | CDI\_Extension\_Date | :grey\_question: |
| TimePoint2       | FruitStroop\_Date    | :grey\_question: |
| TimePoint2       | KBIT\_Date           | :grey\_question: |
| TimePoint3       | KBIT\_Date           | :grey\_question: |
| LateTalker       | MBCDI\_Date          | :grey\_question: |
| LateTalker       | CDI\_Extension\_Date | :grey\_question: |
| LateTalker       | FruitStroop\_Date    | :grey\_question: |
| CochlearV1       | CDI\_Extension\_Date | :grey\_question: |
| CochlearV1       | MBCDI\_Date          | :grey\_question: |
| CochlearV1       | FruitStroop\_Date    | :grey\_question: |
| CochlearV1       | CDI W&G              | :grey\_question: |
| CochlearV2       | MBCDI\_Date          | :grey\_question: |
| CochlearV2       | CDI\_Extension\_Date | :grey\_question: |
| CochlearV2       | FruitStroop\_Date    | :grey\_question: |
| CochlearMatching | CDI\_Extension\_Date | :grey\_question: |
| CochlearMatching | MBCDI\_Date          | :grey\_question: |
| CochlearMatching | FruitStroop\_Date    | :grey\_question: |
| Medu             | FruitStroop\_Date    | :grey\_question: |
| Medu             | MBCDI\_Date          | :grey\_question: |
| Medu             | CDI\_Extension\_Date | :grey\_question: |
