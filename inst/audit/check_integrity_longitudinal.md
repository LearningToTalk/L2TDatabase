Longitudinal Data Integrity Check
================
Tristan Mahr
2016-06-09

In Spring 2015, we had our data-entry team re-enter test scores gathered in the longitudinal study, so that we could find data-entry discrepancies. This script compares the original to the re-entered scores.

Participant pool comparison
---------------------------

Do the same participants contribute scores in each set?

Participants in original score-set ("ParticipantInfo") *not in* the re-entered score-set ("DIRT"):

    #> Source: local data frame [0 x 4]
    #> 
    #> Variables not shown: Study (chr), ParticipantID (chr), DIRT (lgl),
    #>   ParticipantInfo (lgl)

Participants in re-entered score-set ("DIRT") who visited the lab but are *not in* the original score-set ("ParticipantInfo").

    #> Source: local data frame [4 x 4]
    #> 
    #>        Study ParticipantID  DIRT ParticipantInfo
    #>        (chr)         (chr) (lgl)           (lgl)
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
| DELV\_LanguageVar\_ColumnAScore          | FALSE   | :x:                  |
| DELV\_LanguageVar\_ColumnBScore          | FALSE   | :x:                  |
| EVT\_Date                                | TRUE    | :white\_check\_mark: |
| EVT\_Form                                | FALSE   | :x:                  |
| EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| FruitStroop\_Score                       | FALSE   | :x:                  |
| GFTA\_Date                               | FALSE   | :x:                  |
| KBIT\_Raw                                | TRUE    | :white\_check\_mark: |
| KBIT\_Standard                           | TRUE    | :white\_check\_mark: |
| PPVT\_Date                               | FALSE   | :x:                  |
| PPVT\_Form                               | FALSE   | :x:                  |
| PPVT\_GSV                                | FALSE   | :x:                  |
| PPVT\_Raw                                | FALSE   | :x:                  |
| PPVT\_Standard                           | FALSE   | :x:                  |
| VerbalFluency\_AgeEquivalent             | FALSE   | :x:                  |
| VerbalFluency\_Score                     | FALSE   | :x:                  |

### Details

These are all the mismatching values.

    #> $CTOPPMemory_Date
    #>         Study ParticipantID         Variable       DIRT ParticipantInfo
    #> 1  TimePoint3          600L CTOPPMemory_Date 2014-12-12            <NA>
    #> 2  TimePoint3          602L CTOPPMemory_Date 2014-12-18            <NA>
    #> 3  TimePoint3          604L CTOPPMemory_Date 2014-12-01            <NA>
    #> 4  TimePoint3          605L CTOPPMemory_Date 2014-11-15            <NA>
    #> 5  TimePoint3          607L CTOPPMemory_Date 2014-12-16            <NA>
    #> 6  TimePoint3          608L CTOPPMemory_Date 2014-12-22            <NA>
    #> 7  TimePoint3          609L CTOPPMemory_Date 2014-12-12            <NA>
    #> 8  TimePoint3          610L CTOPPMemory_Date 2014-11-21            <NA>
    #> 9  TimePoint3          611L CTOPPMemory_Date 2015-03-13            <NA>
    #> 10 TimePoint3          612L CTOPPMemory_Date 2015-01-26            <NA>
    #> 11 TimePoint3          614L CTOPPMemory_Date 2015-01-05            <NA>
    #> 12 TimePoint3          615L CTOPPMemory_Date 2015-05-04            <NA>
    #> 13 TimePoint3          616L CTOPPMemory_Date 2015-01-15            <NA>
    #> 14 TimePoint3          619L CTOPPMemory_Date 2015-04-04            <NA>
    #> 15 TimePoint3          620L CTOPPMemory_Date 2015-01-16            <NA>
    #> 16 TimePoint3          622L CTOPPMemory_Date 2015-02-28            <NA>
    #> 17 TimePoint3          623L CTOPPMemory_Date 2015-02-13            <NA>
    #> 18 TimePoint3          624L CTOPPMemory_Date 2015-02-27            <NA>
    #> 19 TimePoint3          625L CTOPPMemory_Date 2015-02-03            <NA>
    #> 20 TimePoint3          627L CTOPPMemory_Date 2015-02-03            <NA>
    #> 21 TimePoint3          628L CTOPPMemory_Date 2015-04-09            <NA>
    #> 22 TimePoint3          629L CTOPPMemory_Date 2015-05-01            <NA>
    #> 23 TimePoint3          630L CTOPPMemory_Date 2016-01-12            <NA>
    #> 24 TimePoint3          631L CTOPPMemory_Date 2015-06-06            <NA>
    #> 25 TimePoint3          632L CTOPPMemory_Date 2015-04-21            <NA>
    #> 26 TimePoint3          636L CTOPPMemory_Date 2015-05-04            <NA>
    #> 27 TimePoint3          638L CTOPPMemory_Date 2015-06-08            <NA>
    #> 28 TimePoint3          639L CTOPPMemory_Date 2015-05-29            <NA>
    #> 29 TimePoint3          640L CTOPPMemory_Date 2015-05-30            <NA>
    #> 30 TimePoint3          644L CTOPPMemory_Date 2015-08-19            <NA>
    #> 31 TimePoint3          651L CTOPPMemory_Date 2015-10-24            <NA>
    #> 32 TimePoint3          652L CTOPPMemory_Date 2015-07-16            <NA>
    #> 33 TimePoint3          655L CTOPPMemory_Date 2015-12-01            <NA>
    #> 34 TimePoint3          656L CTOPPMemory_Date 2015-07-20            <NA>
    #> 35 TimePoint3          657L CTOPPMemory_Date 2015-09-18            <NA>
    #> 36 TimePoint3          658L CTOPPMemory_Date 2015-08-31            <NA>
    #> 37 TimePoint3          659L CTOPPMemory_Date 2015-09-03            <NA>
    #> 38 TimePoint3          660L CTOPPMemory_Date 2015-10-17            <NA>
    #> 39 TimePoint3          661L CTOPPMemory_Date 2015-10-02            <NA>
    #> 40 TimePoint3          664L CTOPPMemory_Date 2015-10-16            <NA>
    #> 41 TimePoint3          665L CTOPPMemory_Date 2015-10-15            <NA>
    #> 42 TimePoint3          666L CTOPPMemory_Date 2015-09-24            <NA>
    #> 43 TimePoint3          667L CTOPPMemory_Date 2015-10-03            <NA>
    #> 44 TimePoint3          668L CTOPPMemory_Date 2015-09-26            <NA>
    #> 45 TimePoint3          669L CTOPPMemory_Date 2015-10-02            <NA>
    #> 46 TimePoint3          670L CTOPPMemory_Date 2015-09-18            <NA>
    #> 47 TimePoint3          671L CTOPPMemory_Date 2015-11-24            <NA>
    #> 48 TimePoint3          673L CTOPPMemory_Date 2015-11-21            <NA>
    #> 49 TimePoint3          674L CTOPPMemory_Date 2015-11-20            <NA>
    #> 50 TimePoint3          677L CTOPPMemory_Date 2015-12-11            <NA>
    #> 51 TimePoint3          678L CTOPPMemory_Date 2015-01-15            <NA>
    #> 52 TimePoint3          679L CTOPPMemory_Date 2016-03-04            <NA>
    #> 53 TimePoint3          680L CTOPPMemory_Date 2015-12-10            <NA>
    #> 54 TimePoint3          681L CTOPPMemory_Date 2016-02-02            <NA>
    #> 55 TimePoint3          683L CTOPPMemory_Date 2016-02-01            <NA>
    #> 56 TimePoint3          684L CTOPPMemory_Date 2016-01-16            <NA>
    #> 57 TimePoint3          685L CTOPPMemory_Date 2016-02-13            <NA>
    #> 58 TimePoint3          686L CTOPPMemory_Date 2016-02-13            <NA>
    #> 59 TimePoint3          689L CTOPPMemory_Date 2016-02-23            <NA>
    #> 
    #> $DELV_Date
    #>         Study ParticipantID  Variable       DIRT ParticipantInfo
    #> 1  TimePoint3          605L DELV_Date 2014-11-18           41961
    #> 2  TimePoint3          608L DELV_Date 2015-01-09           42013
    #> 3  TimePoint3          609L DELV_Date 2014-12-19           41992
    #> 4  TimePoint3          631L DELV_Date 2015-06-20            <NA>
    #> 5  TimePoint3          633L DELV_Date       <NA>           42167
    #> 6  TimePoint3          638L DELV_Date 2015-06-12            <NA>
    #> 7  TimePoint3          660L DELV_Date 2015-11-14           42322
    #> 8  TimePoint3          665L DELV_Date 2016-01-07           42376
    #> 9  TimePoint3          666L DELV_Date 2015-10-09            <NA>
    #> 10 TimePoint3          671L DELV_Date 2015-12-19           42357
    #> 11 TimePoint3          677L DELV_Date 2016-01-08           42377
    #> 12 TimePoint3          679L DELV_Date 2016-03-05           42434
    #> 13 TimePoint3          680L DELV_Date 2016-01-07           42376
    #> 14 TimePoint3          681L DELV_Date 2016-02-23           42423
    #> 15 TimePoint3          684L DELV_Date 2016-02-27           42427
    #> 16 TimePoint3          685L DELV_Date 2016-03-12            <NA>
    #> 17 TimePoint3          686L DELV_Date 2016-03-12           42441
    #> 
    #> $DELV_LanguageRisk
    #>         Study ParticipantID          Variable DIRT ParticipantInfo
    #> 1  TimePoint3          001L DELV_LanguageRisk   NA               3
    #> 2  TimePoint3          023L DELV_LanguageRisk   NA               3
    #> 3  TimePoint3          025L DELV_LanguageRisk   NA               2
    #> 4  TimePoint3          027L DELV_LanguageRisk   NA               3
    #> 5  TimePoint3          035L DELV_LanguageRisk   NA               2
    #> 6  TimePoint3          036L DELV_LanguageRisk   NA               1
    #> 7  TimePoint3          049L DELV_LanguageRisk   NA               3
    #> 8  TimePoint3          065L DELV_LanguageRisk   NA               3
    #> 9  TimePoint3          066L DELV_LanguageRisk   NA               3
    #> 10 TimePoint3          089L DELV_LanguageRisk   NA               3
    #> 11 TimePoint3          093L DELV_LanguageRisk   NA               0
    #> 12 TimePoint3          094L DELV_LanguageRisk   NA               3
    #> 13 TimePoint3          108L DELV_LanguageRisk   NA               0
    #> 14 TimePoint3          128L DELV_LanguageRisk   NA               0
    #> 15 TimePoint3          605L DELV_LanguageRisk    4               3
    #> 16 TimePoint3          608L DELV_LanguageRisk    1               0
    #> 17 TimePoint3          609L DELV_LanguageRisk    4               3
    #> 18 TimePoint3          633L DELV_LanguageRisk   NA               0
    #> 19 TimePoint3          660L DELV_LanguageRisk   NA               1
    #> 20 TimePoint3          665L DELV_LanguageRisk   NA               3
    #> 21 TimePoint3          671L DELV_LanguageRisk   NA               2
    #> 22 TimePoint3          677L DELV_LanguageRisk   NA               3
    #> 23 TimePoint3          679L DELV_LanguageRisk   NA               3
    #> 24 TimePoint3          680L DELV_LanguageRisk   NA               3
    #> 25 TimePoint3          681L DELV_LanguageRisk   NA               0
    #> 26 TimePoint3          684L DELV_LanguageRisk   NA               0
    #> 27 TimePoint3          686L DELV_LanguageRisk   NA               3
    #> 
    #> $DELV_LanguageRisk_DiagnosticErrorScore
    #>         Study ParticipantID                               Variable DIRT
    #> 1  TimePoint3          001L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 2  TimePoint3          023L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 3  TimePoint3          025L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 4  TimePoint3          027L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 5  TimePoint3          035L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 6  TimePoint3          036L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 7  TimePoint3          049L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 8  TimePoint3          065L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 9  TimePoint3          066L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 10 TimePoint3          089L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 11 TimePoint3          093L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 12 TimePoint3          094L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 13 TimePoint3          108L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 14 TimePoint3          128L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 15 TimePoint3          605L DELV_LanguageRisk_DiagnosticErrorScore   18
    #> 16 TimePoint3          633L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 17 TimePoint3          660L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 18 TimePoint3          665L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 19 TimePoint3          671L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 20 TimePoint3          677L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 21 TimePoint3          679L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 22 TimePoint3          680L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 23 TimePoint3          681L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 24 TimePoint3          684L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 25 TimePoint3          686L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #>    ParticipantInfo
    #> 1               23
    #> 2               15
    #> 3                7
    #> 4               14
    #> 5               10
    #> 6                7
    #> 7               12
    #> 8               16
    #> 9                9
    #> 10              19
    #> 11               2
    #> 12              14
    #> 13               0
    #> 14               5
    #> 15              17
    #> 16               6
    #> 17               8
    #> 18              13
    #> 19              11
    #> 20              18
    #> 21              15
    #> 22              20
    #> 23               6
    #> 24               6
    #> 25              17
    #> 
    #> $DELV_LanguageVar_ColumnAScore
    #>        Study ParticipantID                      Variable DIRT
    #> 1 TimePoint3          023L DELV_LanguageVar_ColumnAScore   NA
    #> 2 TimePoint3          024L DELV_LanguageVar_ColumnAScore   NA
    #> 3 TimePoint3          025L DELV_LanguageVar_ColumnAScore   NA
    #> 4 TimePoint3          035L DELV_LanguageVar_ColumnAScore   NA
    #> 5 TimePoint3          036L DELV_LanguageVar_ColumnAScore   NA
    #> 6 TimePoint3          046L DELV_LanguageVar_ColumnAScore   NA
    #> 7 TimePoint3          066L DELV_LanguageVar_ColumnAScore   NA
    #>   ParticipantInfo
    #> 1               8
    #> 2              10
    #> 3              14
    #> 4              13
    #> 5              14
    #> 6              13
    #> 7              13
    #> 
    #> $DELV_LanguageVar_ColumnBScore
    #>        Study ParticipantID                      Variable DIRT
    #> 1 TimePoint3          023L DELV_LanguageVar_ColumnBScore   NA
    #> 2 TimePoint3          024L DELV_LanguageVar_ColumnBScore   NA
    #> 3 TimePoint3          025L DELV_LanguageVar_ColumnBScore   NA
    #> 4 TimePoint3          035L DELV_LanguageVar_ColumnBScore   NA
    #> 5 TimePoint3          036L DELV_LanguageVar_ColumnBScore   NA
    #> 6 TimePoint3          046L DELV_LanguageVar_ColumnBScore   NA
    #> 7 TimePoint3          066L DELV_LanguageVar_ColumnBScore   NA
    #>   ParticipantInfo
    #> 1               5
    #> 2               3
    #> 3               1
    #> 4               0
    #> 5               0
    #> 6               2
    #> 7               0
    #> 
    #> $EVT_Form
    #>        Study ParticipantID Variable DIRT ParticipantInfo
    #> 1 TimePoint1          624L EVT_Form    A            <NA>
    #> 
    #> $FruitStroop_Score
    #>        Study ParticipantID          Variable DIRT ParticipantInfo
    #> 1 TimePoint1          601L FruitStroop_Score   NA            3.00
    #> 2 TimePoint1          635L FruitStroop_Score   NA            2.00
    #> 3 TimePoint2          666L FruitStroop_Score  2.8            2.89
    #> 
    #> $GFTA_Date
    #>         Study ParticipantID  Variable       DIRT ParticipantInfo
    #> 1  TimePoint3          600L GFTA_Date 2014-12-12            <NA>
    #> 2  TimePoint3          602L GFTA_Date 2014-12-18            <NA>
    #> 3  TimePoint3          604L GFTA_Date 2014-12-23            <NA>
    #> 4  TimePoint3          605L GFTA_Date 2014-11-15            <NA>
    #> 5  TimePoint3          607L GFTA_Date 2014-12-16            <NA>
    #> 6  TimePoint3          609L GFTA_Date 2014-12-12            <NA>
    #> 7  TimePoint3          610L GFTA_Date 2014-11-21            <NA>
    #> 8  TimePoint3          611L GFTA_Date 2015-03-27            <NA>
    #> 9  TimePoint3          612L GFTA_Date 2015-01-26            <NA>
    #> 10 TimePoint3          614L GFTA_Date 2015-01-05            <NA>
    #> 11 TimePoint3          615L GFTA_Date 2015-05-21            <NA>
    #> 12 TimePoint3          616L GFTA_Date 2015-02-07            <NA>
    #> 13 TimePoint3          619L GFTA_Date 2015-02-28            <NA>
    #> 14 TimePoint3          620L GFTA_Date 2015-01-23            <NA>
    #> 15 TimePoint3          622L GFTA_Date 2015-03-12            <NA>
    #> 16 TimePoint3          623L GFTA_Date 2015-02-27            <NA>
    #> 17 TimePoint3          624L GFTA_Date 2015-03-06            <NA>
    #> 18 TimePoint3          625L GFTA_Date 2015-03-24            <NA>
    #> 19 TimePoint3          627L GFTA_Date 2015-02-07            <NA>
    #> 20 TimePoint3          628L GFTA_Date 2015-04-30            <NA>
    #> 21 TimePoint3          629L GFTA_Date 2015-05-08            <NA>
    #> 22 TimePoint3          630L GFTA_Date 2016-01-19            <NA>
    #> 23 TimePoint3          631L GFTA_Date 2015-06-13            <NA>
    #> 24 TimePoint3          632L GFTA_Date 2015-05-02            <NA>
    #> 25 TimePoint3          636L GFTA_Date 2015-05-11            <NA>
    #> 26 TimePoint3          638L GFTA_Date 2015-06-10            <NA>
    #> 27 TimePoint3          639L GFTA_Date 2015-06-09            <NA>
    #> 28 TimePoint3          640L GFTA_Date 2015-06-13            <NA>
    #> 29 TimePoint3          644L GFTA_Date 2015-08-21            <NA>
    #> 30 TimePoint3          651L GFTA_Date 2015-11-07            <NA>
    #> 31 TimePoint3          652L GFTA_Date 2015-07-30            <NA>
    #> 32 TimePoint3          655L GFTA_Date 2015-12-18            <NA>
    #> 33 TimePoint3          656L GFTA_Date 2015-07-27            <NA>
    #> 34 TimePoint3          657L GFTA_Date 2015-09-25            <NA>
    #> 35 TimePoint3          658L GFTA_Date 2015-09-01            <NA>
    #> 36 TimePoint3          659L GFTA_Date 2015-09-11            <NA>
    #> 37 TimePoint3          660L GFTA_Date 2015-11-14            <NA>
    #> 38 TimePoint3          661L GFTA_Date 2015-11-06            <NA>
    #> 39 TimePoint3          664L GFTA_Date 2015-11-11            <NA>
    #> 40 TimePoint3          665L GFTA_Date 2015-11-21            <NA>
    #> 41 TimePoint3          666L GFTA_Date 2015-10-08            <NA>
    #> 42 TimePoint3          667L GFTA_Date 2015-10-24            <NA>
    #> 43 TimePoint3          668L GFTA_Date 2015-10-10            <NA>
    #> 44 TimePoint3          669L GFTA_Date 2015-10-09            <NA>
    #> 45 TimePoint3          670L GFTA_Date 2015-09-25            <NA>
    #> 46 TimePoint3          671L GFTA_Date 2015-12-12            <NA>
    #> 47 TimePoint3          673L GFTA_Date 2015-12-19            <NA>
    #> 48 TimePoint3          674L GFTA_Date 2015-12-04            <NA>
    #> 49 TimePoint3          677L GFTA_Date 2016-01-05            <NA>
    #> 50 TimePoint3          678L GFTA_Date 2016-02-19            <NA>
    #> 51 TimePoint3          679L GFTA_Date 2016-03-09            <NA>
    #> 52 TimePoint3          680L GFTA_Date 2015-12-17            <NA>
    #> 53 TimePoint3          681L GFTA_Date 2016-02-09            <NA>
    #> 54 TimePoint3          683L GFTA_Date 2016-02-26            <NA>
    #> 55 TimePoint3          684L GFTA_Date 2016-01-30            <NA>
    #> 56 TimePoint3          685L GFTA_Date 2016-02-20            <NA>
    #> 57 TimePoint3          686L GFTA_Date 2016-02-20            <NA>
    #> 58 TimePoint3          689L GFTA_Date 2016-03-01            <NA>
    #> 
    #> $PPVT_Date
    #>        Study ParticipantID  Variable       DIRT ParticipantInfo
    #> 1 TimePoint1          609L PPVT_Date 2010-01-07      2016-01-07
    #> 2 TimePoint1          628L PPVT_Date 2013-05-08      2016-05-08
    #> 
    #> $PPVT_Form
    #>        Study ParticipantID  Variable DIRT ParticipantInfo
    #> 1 TimePoint1          631L PPVT_Form <NA>               A
    #> 2 TimePoint1          635L PPVT_Form <NA>               A
    #> 3 TimePoint3          089L PPVT_Form    A            <NA>
    #> 
    #> $PPVT_GSV
    #>        Study ParticipantID Variable DIRT ParticipantInfo
    #> 1 TimePoint1          657L PPVT_GSV  110              90
    #> 2 TimePoint1          661L PPVT_GSV   NA             110
    #> 
    #> $PPVT_Raw
    #>        Study ParticipantID Variable DIRT ParticipantInfo
    #> 1 TimePoint2          656L PPVT_Raw   91              90
    #> 
    #> $PPVT_Standard
    #>        Study ParticipantID      Variable DIRT ParticipantInfo
    #> 1 TimePoint1          628L PPVT_Standard  119             116
    #> 2 TimePoint1          661L PPVT_Standard   NA             122
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
