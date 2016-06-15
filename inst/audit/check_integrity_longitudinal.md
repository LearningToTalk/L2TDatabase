Longitudinal Data Integrity Check
================
Tristan Mahr
2016-06-15

In Spring 2015, we had our data-entry team re-enter test scores gathered in the longitudinal study, so that we could find data-entry discrepancies. This script compares the original to the re-entered scores.

Participant pool comparison
---------------------------

Do the same participants contribute scores in each set?

Participants in original score-set ("ParticipantInfo") *not in* the re-entered score-set ("DIRT"):

    #> Source: local data frame [0 x 4]
    #> 
    #> Variables not shown: Study <chr>, ParticipantID <chr>, DIRT <lgl>,
    #>   ParticipantInfo <lgl>.

Participants in re-entered score-set ("DIRT") who visited the lab but are *not in* the original score-set ("ParticipantInfo").

    #> Source: local data frame [4 x 4]
    #> 
    #>        Study ParticipantID  DIRT ParticipantInfo
    #>        <chr>         <chr> <lgl>           <lgl>
    #> 1 TimePoint1          648L  TRUE              NA
    #> 2 TimePoint1          672L  TRUE              NA
    #> 3 TimePoint1          662L  TRUE              NA
    #> 4 TimePoint1          687L  TRUE              NA

Value Comparison
----------------

We now compare the scores in each score-set. This check is only being performed on participants in both score-sets.

### Unchecked fields

The following columns in DIRT are not being checked because there is not a matching column in the participant info spreadsheets

| Variable                |                  |
|:------------------------|------------------|
| BRIEFP\_Date            | :grey\_question: |
| CDI\_Extension\_Date    | :grey\_question: |
| CTOPPBlending\_Date     | :grey\_question: |
| CTOPPElision\_Date      | :grey\_question: |
| DELV\_DegreeLanguageVar | :grey\_question: |
| DELV\_LanguageVar       | :grey\_question: |
| FruitStroop\_Date       | :grey\_question: |
| KBIT\_Date              | :grey\_question: |
| MBCDI\_Date             | :grey\_question: |
| VerbalFluency\_Date     | :grey\_question: |

### Summary

This table lists all the fields that were checked and whether any discrepancies were found in that field.

| Variable                                 | Passing |                      |
|:-----------------------------------------|:--------|----------------------|
| CTOPPBlending\_Raw                       | TRUE    | :white\_check\_mark: |
| CTOPPBlending\_Scaled                    | TRUE    | :white\_check\_mark: |
| CTOPPElision\_Raw                        | TRUE    | :white\_check\_mark: |
| CTOPPElision\_Scaled                     | TRUE    | :white\_check\_mark: |
| CTOPPMemory\_Date                        | FALSE   | :x:                  |
| CTOPPMemory\_Raw                         | TRUE    | :white\_check\_mark: |
| CTOPPMemory\_Scaled                      | TRUE    | :white\_check\_mark: |
| DELV\_Date                               | FALSE   | :x:                  |
| DELV\_LanguageRisk                       | FALSE   | :x:                  |
| DELV\_LanguageRisk\_DiagnosticErrorScore | FALSE   | :x:                  |
| DELV\_LanguageVar\_ColumnAScore          | TRUE    | :white\_check\_mark: |
| DELV\_LanguageVar\_ColumnBScore          | TRUE    | :white\_check\_mark: |
| EVT\_Date                                | TRUE    | :white\_check\_mark: |
| EVT\_Form                                | TRUE    | :white\_check\_mark: |
| EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| FruitStroop\_Score                       | FALSE   | :x:                  |
| GFTA\_Date                               | FALSE   | :x:                  |
| KBIT\_Raw                                | TRUE    | :white\_check\_mark: |
| KBIT\_Standard                           | TRUE    | :white\_check\_mark: |
| PPVT\_Date                               | FALSE   | :x:                  |
| PPVT\_Form                               | FALSE   | :x:                  |
| PPVT\_GSV                                | TRUE    | :white\_check\_mark: |
| PPVT\_Raw                                | TRUE    | :white\_check\_mark: |
| PPVT\_Standard                           | TRUE    | :white\_check\_mark: |
| VerbalFluency\_AgeEquivalent             | FALSE   | :x:                  |
| VerbalFluency\_Score                     | FALSE   | :x:                  |

### Details

These are all the mismatching values.

    #> $CTOPPMemory_Date
    #>        Study ParticipantID         Variable       DIRT ParticipantInfo
    #> 1 TimePoint3          600L CTOPPMemory_Date 2014-12-12      2012-12-12
    #> 2 TimePoint3          673L CTOPPMemory_Date 2015-11-21      2015-11-02
    #> 3 TimePoint3          678L CTOPPMemory_Date 2015-01-15      2016-01-15
    #> 4 TimePoint3          685L CTOPPMemory_Date 2016-02-13      2016-02-11
    #> 5 TimePoint3          686L CTOPPMemory_Date 2016-02-13      2016-02-11
    #> 
    #> $DELV_Date
    #>        Study ParticipantID  Variable       DIRT ParticipantInfo
    #> 1 TimePoint3          631L DELV_Date 2015-06-20            <NA>
    #> 2 TimePoint3          633L DELV_Date       <NA>      2015-06-12
    #> 3 TimePoint3          638L DELV_Date 2015-06-12            <NA>
    #> 4 TimePoint3          666L DELV_Date 2015-10-09            <NA>
    #> 5 TimePoint3          685L DELV_Date 2016-03-12            <NA>
    #> 
    #> $DELV_LanguageRisk
    #>         Study ParticipantID          Variable DIRT ParticipantInfo
    #> 1  TimePoint3          605L DELV_LanguageRisk    4               3
    #> 2  TimePoint3          608L DELV_LanguageRisk    1               0
    #> 3  TimePoint3          609L DELV_LanguageRisk    4               3
    #> 4  TimePoint3          633L DELV_LanguageRisk   NA               0
    #> 5  TimePoint3          660L DELV_LanguageRisk   NA               1
    #> 6  TimePoint3          665L DELV_LanguageRisk   NA               3
    #> 7  TimePoint3          671L DELV_LanguageRisk   NA               2
    #> 8  TimePoint3          677L DELV_LanguageRisk   NA               3
    #> 9  TimePoint3          679L DELV_LanguageRisk   NA               3
    #> 10 TimePoint3          680L DELV_LanguageRisk   NA               3
    #> 11 TimePoint3          681L DELV_LanguageRisk   NA               0
    #> 12 TimePoint3          684L DELV_LanguageRisk   NA               0
    #> 13 TimePoint3          686L DELV_LanguageRisk   NA               3
    #> 
    #> $DELV_LanguageRisk_DiagnosticErrorScore
    #>         Study ParticipantID                               Variable DIRT
    #> 1  TimePoint3          605L DELV_LanguageRisk_DiagnosticErrorScore   18
    #> 2  TimePoint3          633L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 3  TimePoint3          660L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 4  TimePoint3          665L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 5  TimePoint3          671L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 6  TimePoint3          677L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 7  TimePoint3          679L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 8  TimePoint3          680L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 9  TimePoint3          681L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 10 TimePoint3          684L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 11 TimePoint3          686L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #>    ParticipantInfo
    #> 1               17
    #> 2                6
    #> 3                8
    #> 4               13
    #> 5               11
    #> 6               18
    #> 7               15
    #> 8               20
    #> 9                6
    #> 10               6
    #> 11              17
    #> 
    #> $FruitStroop_Score
    #>        Study ParticipantID          Variable DIRT ParticipantInfo
    #> 1 TimePoint1          635L FruitStroop_Score   NA               2
    #> 
    #> $GFTA_Date
    #>         Study ParticipantID  Variable       DIRT ParticipantInfo
    #> 1  TimePoint1          022L GFTA_Date 2013-05-20      2013-05-22
    #> 2  TimePoint1          075L GFTA_Date 2013-08-28      2013-09-14
    #> 3  TimePoint1          085L GFTA_Date 2013-10-02            <NA>
    #> 4  TimePoint1          110L GFTA_Date 2014-01-24      2014-02-14
    #> 5  TimePoint1          602L GFTA_Date 2012-12-11      2012-12-18
    #> 6  TimePoint1          616L GFTA_Date 2013-02-01            <NA>
    #> 7  TimePoint1          624L GFTA_Date 2013-04-11            <NA>
    #> 8  TimePoint1          631L GFTA_Date 2013-06-15            <NA>
    #> 9  TimePoint1          632L GFTA_Date 2013-06-21      2013-06-28
    #> 10 TimePoint1          646L GFTA_Date       <NA>      2013-08-05
    #> 11 TimePoint1          655L GFTA_Date 2013-12-10      2014-01-16
    #> 12 TimePoint1          667L GFTA_Date       <NA>      2013-11-02
    #> 13 TimePoint1          669L GFTA_Date       <NA>      2013-10-29
    #> 14 TimePoint1          688L GFTA_Date 2014-05-10            <NA>
    #> 15 TimePoint3          600L GFTA_Date 2014-12-12            <NA>
    #> 16 TimePoint3          602L GFTA_Date 2014-12-18            <NA>
    #> 17 TimePoint3          604L GFTA_Date 2014-12-23            <NA>
    #> 18 TimePoint3          605L GFTA_Date 2014-11-15            <NA>
    #> 19 TimePoint3          607L GFTA_Date 2014-12-16            <NA>
    #> 20 TimePoint3          608L GFTA_Date 2014-12-30            <NA>
    #> 21 TimePoint3          609L GFTA_Date 2014-12-12            <NA>
    #> 22 TimePoint3          610L GFTA_Date 2014-11-21            <NA>
    #> 23 TimePoint3          611L GFTA_Date 2015-03-27            <NA>
    #> 24 TimePoint3          612L GFTA_Date 2015-01-26            <NA>
    #> 25 TimePoint3          614L GFTA_Date 2015-01-05            <NA>
    #> 26 TimePoint3          615L GFTA_Date 2015-05-21            <NA>
    #> 27 TimePoint3          616L GFTA_Date 2015-02-07            <NA>
    #> 28 TimePoint3          619L GFTA_Date 2015-02-28            <NA>
    #> 29 TimePoint3          620L GFTA_Date 2015-01-23            <NA>
    #> 30 TimePoint3          622L GFTA_Date 2015-03-12            <NA>
    #> 31 TimePoint3          623L GFTA_Date 2015-02-27            <NA>
    #> 32 TimePoint3          624L GFTA_Date 2015-03-06            <NA>
    #> 33 TimePoint3          625L GFTA_Date 2015-03-24            <NA>
    #> 34 TimePoint3          627L GFTA_Date 2015-02-07            <NA>
    #> 35 TimePoint3          628L GFTA_Date 2015-04-30            <NA>
    #> 36 TimePoint3          629L GFTA_Date 2015-05-08            <NA>
    #> 37 TimePoint3          630L GFTA_Date 2016-01-19            <NA>
    #> 38 TimePoint3          631L GFTA_Date 2015-06-13            <NA>
    #> 39 TimePoint3          632L GFTA_Date 2015-05-02            <NA>
    #> 40 TimePoint3          636L GFTA_Date 2015-05-11            <NA>
    #> 41 TimePoint3          638L GFTA_Date 2015-06-10            <NA>
    #> 42 TimePoint3          639L GFTA_Date 2015-06-09            <NA>
    #> 43 TimePoint3          640L GFTA_Date 2015-06-13            <NA>
    #> 44 TimePoint3          644L GFTA_Date 2015-08-21            <NA>
    #> 45 TimePoint3          651L GFTA_Date 2015-11-07            <NA>
    #> 46 TimePoint3          652L GFTA_Date 2015-07-30            <NA>
    #> 47 TimePoint3          655L GFTA_Date 2015-12-18            <NA>
    #> 48 TimePoint3          656L GFTA_Date 2015-07-27            <NA>
    #> 49 TimePoint3          657L GFTA_Date 2015-09-25            <NA>
    #> 50 TimePoint3          658L GFTA_Date 2015-09-01            <NA>
    #> 51 TimePoint3          659L GFTA_Date 2015-09-11            <NA>
    #> 52 TimePoint3          660L GFTA_Date 2015-11-14            <NA>
    #> 53 TimePoint3          661L GFTA_Date 2015-11-06            <NA>
    #> 54 TimePoint3          664L GFTA_Date 2015-11-11            <NA>
    #> 55 TimePoint3          665L GFTA_Date 2015-11-21            <NA>
    #> 56 TimePoint3          666L GFTA_Date 2015-10-08            <NA>
    #> 57 TimePoint3          667L GFTA_Date 2015-10-24            <NA>
    #> 58 TimePoint3          668L GFTA_Date 2015-10-10            <NA>
    #> 59 TimePoint3          669L GFTA_Date 2015-10-09            <NA>
    #> 60 TimePoint3          670L GFTA_Date 2015-09-25            <NA>
    #> 61 TimePoint3          671L GFTA_Date 2015-12-12            <NA>
    #> 62 TimePoint3          673L GFTA_Date 2015-12-19            <NA>
    #> 63 TimePoint3          674L GFTA_Date 2015-12-04            <NA>
    #> 64 TimePoint3          677L GFTA_Date 2016-01-05            <NA>
    #> 65 TimePoint3          678L GFTA_Date 2016-02-19            <NA>
    #> 66 TimePoint3          679L GFTA_Date 2016-03-09            <NA>
    #> 67 TimePoint3          680L GFTA_Date 2015-12-17            <NA>
    #> 68 TimePoint3          681L GFTA_Date 2016-02-09            <NA>
    #> 69 TimePoint3          683L GFTA_Date 2016-02-26            <NA>
    #> 70 TimePoint3          684L GFTA_Date 2016-01-30            <NA>
    #> 71 TimePoint3          685L GFTA_Date 2016-02-20            <NA>
    #> 72 TimePoint3          686L GFTA_Date 2016-02-20            <NA>
    #> 73 TimePoint3          689L GFTA_Date 2016-03-01            <NA>
    #> 
    #> $PPVT_Date
    #>        Study ParticipantID  Variable       DIRT ParticipantInfo
    #> 1 TimePoint1          609L PPVT_Date 2010-01-07      2013-01-07
    #> 
    #> $PPVT_Form
    #>        Study ParticipantID  Variable DIRT ParticipantInfo
    #> 1 TimePoint1          635L PPVT_Form <NA>               A
    #> 
    #> $VerbalFluency_AgeEquivalent
    #>        Study ParticipantID                    Variable DIRT
    #> 1 TimePoint1          635L VerbalFluency_AgeEquivalent <NA>
    #>   ParticipantInfo
    #> 1            <2;0
    #> 
    #> $VerbalFluency_Score
    #>        Study ParticipantID            Variable DIRT ParticipantInfo
    #> 1 TimePoint1          635L VerbalFluency_Score   NA               0
