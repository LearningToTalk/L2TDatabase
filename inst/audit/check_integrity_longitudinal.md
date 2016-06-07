Longitudinal Data Integrity Check
================
Tristan Mahr
2016-06-07

In Spring 2015, we had our data-entry team re-enter test scores gathered in the longitudinal study, so that we could find data-entry discrepancies. This script compares the original to the re-entered scores.

Participant pool comparison
---------------------------

Do the same participants contribute scores in each set?

Participants in original score-set ("ParticipantInfo") *not in* the re-entered score-set ("DIRT"):

    #> Source: local data frame [1 x 4]
    #> 
    #>        Study ParticipantID  DIRT ParticipantInfo
    #>        (chr)         (chr) (lgl)           (lgl)
    #> 1 TimePoint2          635L    NA            TRUE

Participants in re-entered score-set ("DIRT") who visited the lab but are *not in* the original score-set ("ParticipantInfo").

    #> Source: local data frame [5 x 4]
    #> 
    #>        Study    ParticipantID  DIRT ParticipantInfo
    #>        (chr)            (chr) (lgl)           (lgl)
    #> 1 TimePoint1             662L  TRUE              NA
    #> 2 TimePoint1             648L  TRUE              NA
    #> 3 TimePoint1             687L  TRUE              NA
    #> 4 TimePoint1             672L  TRUE              NA
    #> 5 TimePoint2 635L (no folder)  TRUE              NA

Value Comparison
----------------

We now compare the scores in each score-set. This check is only being performed on participants in both score-sets.

### Unchecked fields

The following columns in DIRT are not being checked because there is not a matching column in the participant info spreadsheets

| Variable             |                  |
|:---------------------|------------------|
| BRIEFP\_Date         | :grey\_question: |
| CDI\_Extension\_Date | :grey\_question: |
| CTOPPBlending\_Date  | :grey\_question: |
| CTOPPElision\_Date   | :grey\_question: |
| CTOPPMemory\_Date    | :grey\_question: |
| CTOPPMemory\_Raw     | :grey\_question: |
| CTOPPMemory\_Scaled  | :grey\_question: |
| FruitStroop\_Date    | :grey\_question: |
| KBIT\_Date           | :grey\_question: |
| MBCDI\_Date          | :grey\_question: |
| VerbalFluency\_Date  | :grey\_question: |

### Summary

This table lists all the fields that were checked and whether any discrepancies were found in that field.

| Variable                                 | Passing |                      |
|:-----------------------------------------|:--------|----------------------|
| CTOPPBlending\_Raw                       | TRUE    | :white\_check\_mark: |
| CTOPPBlending\_Scaled                    | FALSE   | :x:                  |
| CTOPPElision\_Raw                        | TRUE    | :white\_check\_mark: |
| CTOPPElision\_Scaled                     | TRUE    | :white\_check\_mark: |
| DELV\_Date                               | FALSE   | :x:                  |
| DELV\_LanguageRisk                       | FALSE   | :x:                  |
| DELV\_LanguageRisk\_DiagnosticErrorScore | FALSE   | :x:                  |
| DELV\_LanguageVar                        | FALSE   | :x:                  |
| DELV\_LanguageVar\_ColumnAScore          | TRUE    | :white\_check\_mark: |
| DELV\_LanguageVar\_ColumnBScore          | TRUE    | :white\_check\_mark: |
| EVT\_Date                                | FALSE   | :x:                  |
| EVT\_Form                                | FALSE   | :x:                  |
| EVT\_GSV                                 | FALSE   | :x:                  |
| EVT\_Raw                                 | FALSE   | :x:                  |
| EVT\_Standard                            | FALSE   | :x:                  |
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

    #> $CTOPPBlending_Scaled
    #>        Study ParticipantID             Variable DIRT ParticipantInfo
    #> 1 TimePoint3          671L CTOPPBlending_Scaled    1              10
    #> 
    #> $DELV_Date
    #>         Study ParticipantID  Variable       DIRT ParticipantInfo
    #> 1  TimePoint3          001L DELV_Date 2015-08-03            <NA>
    #> 2  TimePoint3          023L DELV_Date 2015-06-01            <NA>
    #> 3  TimePoint3          024L DELV_Date 2015-03-13            <NA>
    #> 4  TimePoint3          025L DELV_Date 2015-07-06            <NA>
    #> 5  TimePoint3          027L DELV_Date 2015-03-06            <NA>
    #> 6  TimePoint3          035L DELV_Date 2015-06-20            <NA>
    #> 7  TimePoint3          036L DELV_Date 2015-05-13            <NA>
    #> 8  TimePoint3          046L DELV_Date 2015-04-15            <NA>
    #> 9  TimePoint3          049L DELV_Date 2015-08-17            <NA>
    #> 10 TimePoint3          065L DELV_Date 2015-07-09            <NA>
    #> 11 TimePoint3          066L DELV_Date 2015-06-25            <NA>
    #> 12 TimePoint3          089L DELV_Date 2015-10-03            <NA>
    #> 13 TimePoint3          093L DELV_Date 2015-11-23            <NA>
    #> 14 TimePoint3          094L DELV_Date 2015-11-23            <NA>
    #> 15 TimePoint3          108L DELV_Date 2016-02-08            <NA>
    #> 16 TimePoint3          128L DELV_Date 2016-01-29            <NA>
    #> 17 TimePoint3          605L DELV_Date 2014-11-18            <NA>
    #> 18 TimePoint3          608L DELV_Date 2015-01-09            <NA>
    #> 19 TimePoint3          609L DELV_Date 2014-12-19            <NA>
    #> 20 TimePoint3          631L DELV_Date 2015-06-20            <NA>
    #> 21 TimePoint3          638L DELV_Date 2015-06-12            <NA>
    #> 22 TimePoint3          660L DELV_Date 2015-11-14            <NA>
    #> 23 TimePoint3          665L DELV_Date 2016-01-07            <NA>
    #> 24 TimePoint3          666L DELV_Date 2015-10-09            <NA>
    #> 25 TimePoint3          671L DELV_Date 2015-12-19            <NA>
    #> 26 TimePoint3          677L DELV_Date 2016-01-08            <NA>
    #> 27 TimePoint3          679L DELV_Date 2016-03-05            <NA>
    #> 28 TimePoint3          680L DELV_Date 2016-01-07            <NA>
    #> 29 TimePoint3          681L DELV_Date 2016-02-23            <NA>
    #> 30 TimePoint3          684L DELV_Date 2016-02-27            <NA>
    #> 31 TimePoint3          685L DELV_Date 2016-03-12            <NA>
    #> 32 TimePoint3          686L DELV_Date 2016-03-12            <NA>
    #> 
    #> $DELV_LanguageRisk
    #>        Study ParticipantID          Variable DIRT ParticipantInfo
    #> 1 TimePoint3          605L DELV_LanguageRisk    4              NA
    #> 2 TimePoint3          608L DELV_LanguageRisk    1              NA
    #> 3 TimePoint3          609L DELV_LanguageRisk    4              NA
    #> 
    #> $DELV_LanguageRisk_DiagnosticErrorScore
    #>        Study ParticipantID                               Variable DIRT
    #> 1 TimePoint3          605L DELV_LanguageRisk_DiagnosticErrorScore   18
    #> 2 TimePoint3          608L DELV_LanguageRisk_DiagnosticErrorScore    1
    #> 3 TimePoint3          609L DELV_LanguageRisk_DiagnosticErrorScore   13
    #> 4 TimePoint3          631L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #> 5 TimePoint3          638L DELV_LanguageRisk_DiagnosticErrorScore   NA
    #>   ParticipantInfo
    #> 1               3
    #> 2               0
    #> 3               3
    #> 4               0
    #> 5               0
    #> 
    #> $DELV_LanguageVar
    #>        Study ParticipantID         Variable DIRT ParticipantInfo
    #> 1 TimePoint3          638L DELV_LanguageVar   NA               0
    #> 
    #> $EVT_Date
    #>         Study ParticipantID Variable       DIRT ParticipantInfo
    #> 1  TimePoint1          602L EVT_Date 2012-11-27      2012-12-11
    #> 2  TimePoint1          611L EVT_Date 2010-11-19      2012-11-19
    #> 3  TimePoint1          629L EVT_Date 2013-05-17      2013-05-10
    #> 4  TimePoint1          642L EVT_Date 2013-08-26      2013-08-20
    #> 5  TimePoint1          688L EVT_Date 2014-03-08      2014-03-15
    #> 6  TimePoint2          605L EVT_Date 2013-12-02      2013-11-02
    #> 7  TimePoint2          607L EVT_Date 2013-12-16      2013-12-06
    #> 8  TimePoint2          624L EVT_Date 2014-02-07      2014-01-07
    #> 9  TimePoint2          659L EVT_Date 2014-10-18      2014-09-20
    #> 10 TimePoint3          609L EVT_Date 2014-11-14      2014-10-11
    #> 11 TimePoint3          614L EVT_Date 2014-12-29      2014-10-29
    #> 12 TimePoint3          622L EVT_Date 2015-02-28      2015-02-21
    #> 13 TimePoint3          623L EVT_Date 2015-02-13      2015-02-23
    #> 14 TimePoint3          683L EVT_Date 2016-02-01      2016-02-02
    #> 15 TimePoint3          685L EVT_Date 2016-02-13      2016-02-11
    #> 16 TimePoint3          686L EVT_Date 2016-02-13      2016-02-11
    #> 
    #> $EVT_Form
    #>         Study ParticipantID Variable DIRT ParticipantInfo
    #> 1  TimePoint1          048L EVT_Form <NA>               A
    #> 2  TimePoint1          059L EVT_Form <NA>               A
    #> 3  TimePoint1          060L EVT_Form <NA>               A
    #> 4  TimePoint1          070L EVT_Form <NA>               A
    #> 5  TimePoint1          102L EVT_Form <NA>               A
    #> 6  TimePoint1          105L EVT_Form <NA>               A
    #> 7  TimePoint1          115L EVT_Form <NA>               A
    #> 8  TimePoint1          120L EVT_Form <NA>               A
    #> 9  TimePoint1          624L EVT_Form    A            <NA>
    #> 10 TimePoint3          607L EVT_Form    A            <NA>
    #> 11 TimePoint3          608L EVT_Form    A            <NA>
    #> 12 TimePoint3          609L EVT_Form    A            <NA>
    #> 13 TimePoint3          610L EVT_Form    A            <NA>
    #> 14 TimePoint3          611L EVT_Form    A            <NA>
    #> 15 TimePoint3          612L EVT_Form    A            <NA>
    #> 16 TimePoint3          614L EVT_Form    A            <NA>
    #> 17 TimePoint3          615L EVT_Form    A            <NA>
    #> 18 TimePoint3          616L EVT_Form    A            <NA>
    #> 19 TimePoint3          619L EVT_Form    A            <NA>
    #> 20 TimePoint3          620L EVT_Form    A            <NA>
    #> 21 TimePoint3          622L EVT_Form    A            <NA>
    #> 22 TimePoint3          623L EVT_Form    A            <NA>
    #> 23 TimePoint3          624L EVT_Form    A            <NA>
    #> 24 TimePoint3          625L EVT_Form    A            <NA>
    #> 25 TimePoint3          627L EVT_Form    A            <NA>
    #> 26 TimePoint3          628L EVT_Form    A            <NA>
    #> 27 TimePoint3          629L EVT_Form    A            <NA>
    #> 28 TimePoint3          630L EVT_Form    A            <NA>
    #> 29 TimePoint3          631L EVT_Form    A            <NA>
    #> 30 TimePoint3          632L EVT_Form    A            <NA>
    #> 31 TimePoint3          636L EVT_Form    A            <NA>
    #> 32 TimePoint3          638L EVT_Form    A            <NA>
    #> 33 TimePoint3          639L EVT_Form    A            <NA>
    #> 34 TimePoint3          640L EVT_Form    A            <NA>
    #> 35 TimePoint3          644L EVT_Form    A            <NA>
    #> 36 TimePoint3          651L EVT_Form    A            <NA>
    #> 37 TimePoint3          652L EVT_Form    A            <NA>
    #> 38 TimePoint3          655L EVT_Form    A            <NA>
    #> 39 TimePoint3          656L EVT_Form    A            <NA>
    #> 40 TimePoint3          657L EVT_Form    A            <NA>
    #> 41 TimePoint3          658L EVT_Form    A            <NA>
    #> 42 TimePoint3          659L EVT_Form    A            <NA>
    #> 43 TimePoint3          660L EVT_Form    A            <NA>
    #> 44 TimePoint3          661L EVT_Form    A            <NA>
    #> 45 TimePoint3          664L EVT_Form    A            <NA>
    #> 46 TimePoint3          665L EVT_Form    A            <NA>
    #> 47 TimePoint3          666L EVT_Form    A            <NA>
    #> 48 TimePoint3          667L EVT_Form    A            <NA>
    #> 49 TimePoint3          668L EVT_Form    A            <NA>
    #> 50 TimePoint3          669L EVT_Form    A            <NA>
    #> 51 TimePoint3          670L EVT_Form    A            <NA>
    #> 52 TimePoint3          671L EVT_Form    A            <NA>
    #> 53 TimePoint3          673L EVT_Form    A            <NA>
    #> 54 TimePoint3          674L EVT_Form    A            <NA>
    #> 55 TimePoint3          677L EVT_Form    A            <NA>
    #> 56 TimePoint3          678L EVT_Form    A            <NA>
    #> 57 TimePoint3          679L EVT_Form    A            <NA>
    #> 58 TimePoint3          680L EVT_Form    A            <NA>
    #> 59 TimePoint3          681L EVT_Form    A            <NA>
    #> 60 TimePoint3          683L EVT_Form    A            <NA>
    #> 61 TimePoint3          684L EVT_Form    A            <NA>
    #> 62 TimePoint3          685L EVT_Form    A            <NA>
    #> 63 TimePoint3          686L EVT_Form    A            <NA>
    #> 64 TimePoint3          689L EVT_Form    A            <NA>
    #> 
    #> $EVT_GSV
    #>        Study ParticipantID Variable DIRT ParticipantInfo
    #> 1 TimePoint1          616L  EVT_GSV   NA             104
    #> 2 TimePoint1          619L  EVT_GSV  118             123
    #> 3 TimePoint1          622L  EVT_GSV   NA             122
    #> 4 TimePoint1          631L  EVT_GSV   NA             102
    #> 5 TimePoint1          657L  EVT_GSV   NA             121
    #> 6 TimePoint2          659L  EVT_GSV  148             143
    #> 7 TimePoint3          623L  EVT_GSV  145             125
    #> 
    #> $EVT_Raw
    #>        Study ParticipantID Variable DIRT ParticipantInfo
    #> 1 TimePoint1          616L  EVT_Raw   NA              24
    #> 2 TimePoint1          622L  EVT_Raw   NA              44
    #> 3 TimePoint2          659L  EVT_Raw   78              70
    #> 4 TimePoint3          607L  EVT_Raw   80              82
    #> 5 TimePoint3          623L  EVT_Raw   73              48
    #> 
    #> $EVT_Standard
    #>        Study ParticipantID     Variable DIRT ParticipantInfo
    #> 1 TimePoint1          616L EVT_Standard   NA             102
    #> 2 TimePoint1          622L EVT_Standard   NA             129
    #> 3 TimePoint1          631L EVT_Standard   NA              99
    #> 4 TimePoint1          657L EVT_Standard   NA             128
    #> 5 TimePoint2          659L EVT_Standard  137             110
    #> 6 TimePoint3          623L EVT_Standard  116             104
    #> 
    #> $FruitStroop_Score
    #>        Study ParticipantID          Variable DIRT ParticipantInfo
    #> 1 TimePoint1          601L FruitStroop_Score   NA            3.00
    #> 2 TimePoint1          635L FruitStroop_Score   NA            2.00
    #> 3 TimePoint2          666L FruitStroop_Score  2.8            2.89
    #> 
    #> $GFTA_Date
    #>         Study ParticipantID  Variable       DIRT ParticipantInfo
    #> 1  TimePoint3          021L GFTA_Date 2015-04-05      2015-04-04
    #> 2  TimePoint3          097L GFTA_Date 2015-12-05      2015-11-21
    #> 3  TimePoint3          098L GFTA_Date 2015-12-05      2015-11-21
    #> 4  TimePoint3          126L GFTA_Date 2016-02-09      2016-02-14
    #> 5  TimePoint3          130L GFTA_Date 2016-03-06      2016-03-16
    #> 6  TimePoint3          133L GFTA_Date 2016-02-03      2015-02-03
    #> 7  TimePoint3          600L GFTA_Date 2014-12-12            <NA>
    #> 8  TimePoint3          602L GFTA_Date 2014-12-18            <NA>
    #> 9  TimePoint3          604L GFTA_Date 2014-12-23            <NA>
    #> 10 TimePoint3          605L GFTA_Date 2014-11-15            <NA>
    #> 11 TimePoint3          607L GFTA_Date 2014-12-16            <NA>
    #> 12 TimePoint3          609L GFTA_Date 2014-12-12            <NA>
    #> 13 TimePoint3          610L GFTA_Date 2014-11-21            <NA>
    #> 14 TimePoint3          611L GFTA_Date 2015-03-27            <NA>
    #> 15 TimePoint3          612L GFTA_Date 2015-01-26            <NA>
    #> 16 TimePoint3          614L GFTA_Date 2015-01-05            <NA>
    #> 17 TimePoint3          615L GFTA_Date 2015-05-21            <NA>
    #> 18 TimePoint3          616L GFTA_Date 2015-02-07            <NA>
    #> 19 TimePoint3          619L GFTA_Date 2015-02-28            <NA>
    #> 20 TimePoint3          620L GFTA_Date 2015-01-23            <NA>
    #> 21 TimePoint3          622L GFTA_Date 2015-03-12            <NA>
    #> 22 TimePoint3          623L GFTA_Date 2015-02-27            <NA>
    #> 23 TimePoint3          624L GFTA_Date 2015-03-06            <NA>
    #> 24 TimePoint3          625L GFTA_Date 2015-03-24            <NA>
    #> 25 TimePoint3          627L GFTA_Date 2015-02-07            <NA>
    #> 26 TimePoint3          628L GFTA_Date 2015-04-30            <NA>
    #> 27 TimePoint3          629L GFTA_Date 2015-05-08            <NA>
    #> 28 TimePoint3          630L GFTA_Date 2016-01-19            <NA>
    #> 29 TimePoint3          631L GFTA_Date 2015-06-13            <NA>
    #> 30 TimePoint3          632L GFTA_Date 2015-05-02            <NA>
    #> 31 TimePoint3          636L GFTA_Date 2015-05-11            <NA>
    #> 32 TimePoint3          638L GFTA_Date 2015-06-10            <NA>
    #> 33 TimePoint3          639L GFTA_Date 2015-06-09            <NA>
    #> 34 TimePoint3          640L GFTA_Date 2015-06-13            <NA>
    #> 35 TimePoint3          644L GFTA_Date 2015-08-21            <NA>
    #> 36 TimePoint3          651L GFTA_Date 2015-11-07            <NA>
    #> 37 TimePoint3          652L GFTA_Date 2015-07-30            <NA>
    #> 38 TimePoint3          655L GFTA_Date 2015-12-18            <NA>
    #> 39 TimePoint3          656L GFTA_Date 2015-07-27            <NA>
    #> 40 TimePoint3          657L GFTA_Date 2015-09-25            <NA>
    #> 41 TimePoint3          658L GFTA_Date 2015-09-01            <NA>
    #> 42 TimePoint3          659L GFTA_Date 2015-09-11            <NA>
    #> 43 TimePoint3          660L GFTA_Date 2015-11-14            <NA>
    #> 44 TimePoint3          661L GFTA_Date 2015-11-06            <NA>
    #> 45 TimePoint3          664L GFTA_Date 2015-11-11            <NA>
    #> 46 TimePoint3          665L GFTA_Date 2015-11-21            <NA>
    #> 47 TimePoint3          666L GFTA_Date 2015-10-08            <NA>
    #> 48 TimePoint3          667L GFTA_Date 2015-10-24            <NA>
    #> 49 TimePoint3          668L GFTA_Date 2015-10-10            <NA>
    #> 50 TimePoint3          669L GFTA_Date 2015-10-09            <NA>
    #> 51 TimePoint3          670L GFTA_Date 2015-09-25            <NA>
    #> 52 TimePoint3          671L GFTA_Date 2015-12-12            <NA>
    #> 53 TimePoint3          673L GFTA_Date 2015-12-19            <NA>
    #> 54 TimePoint3          674L GFTA_Date 2015-12-04            <NA>
    #> 55 TimePoint3          677L GFTA_Date 2016-01-05            <NA>
    #> 56 TimePoint3          678L GFTA_Date 2016-02-19            <NA>
    #> 57 TimePoint3          679L GFTA_Date 2016-03-09            <NA>
    #> 58 TimePoint3          680L GFTA_Date 2015-12-17            <NA>
    #> 59 TimePoint3          681L GFTA_Date 2016-02-09            <NA>
    #> 60 TimePoint3          683L GFTA_Date 2016-02-26            <NA>
    #> 61 TimePoint3          684L GFTA_Date 2016-01-30            <NA>
    #> 62 TimePoint3          685L GFTA_Date 2016-02-20            <NA>
    #> 63 TimePoint3          686L GFTA_Date 2016-02-20            <NA>
    #> 64 TimePoint3          689L GFTA_Date 2016-03-01            <NA>
    #> 
    #> $PPVT_Date
    #>        Study ParticipantID  Variable       DIRT ParticipantInfo
    #> 1 TimePoint1          602L PPVT_Date 2012-12-18      2012-11-27
    #> 2 TimePoint1          609L PPVT_Date 2010-12-12      2012-12-10
    #> 3 TimePoint1          628L PPVT_Date 2013-05-08      2013-08-05
    #> 4 TimePoint1          644L PPVT_Date 2013-10-08      2013-10-18
    #> 5 TimePoint3          660L PPVT_Date          A      2015-11-14
    #> 
    #> $PPVT_Form
    #>         Study ParticipantID  Variable       DIRT ParticipantInfo
    #> 1  TimePoint1          048L PPVT_Form       <NA>               A
    #> 2  TimePoint1          059L PPVT_Form       <NA>               A
    #> 3  TimePoint1          070L PPVT_Form       <NA>               A
    #> 4  TimePoint1          091L PPVT_Form       <NA>               A
    #> 5  TimePoint1          102L PPVT_Form       <NA>               A
    #> 6  TimePoint1          606L PPVT_Form          A            <NA>
    #> 7  TimePoint1          631L PPVT_Form       <NA>               A
    #> 8  TimePoint1          635L PPVT_Form       <NA>               A
    #> 9  TimePoint3          089L PPVT_Form          A            <NA>
    #> 10 TimePoint3          608L PPVT_Form          A            <NA>
    #> 11 TimePoint3          609L PPVT_Form          A            <NA>
    #> 12 TimePoint3          631L PPVT_Form          A            <NA>
    #> 13 TimePoint3          638L PPVT_Form          A            <NA>
    #> 14 TimePoint3          660L PPVT_Form 2015-11-14            <NA>
    #> 15 TimePoint3          665L PPVT_Form          A            <NA>
    #> 16 TimePoint3          666L PPVT_Form          A            <NA>
    #> 17 TimePoint3          671L PPVT_Form          A            <NA>
    #> 18 TimePoint3          677L PPVT_Form          A            <NA>
    #> 19 TimePoint3          679L PPVT_Form          A            <NA>
    #> 20 TimePoint3          680L PPVT_Form          A            <NA>
    #> 21 TimePoint3          681L PPVT_Form          A            <NA>
    #> 22 TimePoint3          684L PPVT_Form          A            <NA>
    #> 23 TimePoint3          685L PPVT_Form          A            <NA>
    #> 24 TimePoint3          686L PPVT_Form          A            <NA>
    #> 
    #> $PPVT_GSV
    #>        Study ParticipantID Variable DIRT ParticipantInfo
    #> 1 TimePoint1          631L PPVT_GSV   NA              70
    #> 2 TimePoint1          657L PPVT_GSV   NA              90
    #> 3 TimePoint1          661L PPVT_GSV   NA             110
    #> 4 TimePoint1          671L PPVT_GSV   98              97
    #> 
    #> $PPVT_Raw
    #>        Study ParticipantID Variable DIRT ParticipantInfo
    #> 1 TimePoint2          656L PPVT_Raw   91              90
    #> 
    #> $PPVT_Standard
    #>        Study ParticipantID      Variable DIRT ParticipantInfo
    #> 1 TimePoint1          628L PPVT_Standard  119             116
    #> 2 TimePoint1          631L PPVT_Standard   NA              84
    #> 3 TimePoint1          657L PPVT_Standard   NA             101
    #> 4 TimePoint1          661L PPVT_Standard   NA             122
    #> 
    #> $VerbalFluency_AgeEquivalent
    #>        Study ParticipantID                    Variable DIRT
    #> 1 TimePoint1          627L VerbalFluency_AgeEquivalent <NA>
    #> 2 TimePoint1          635L VerbalFluency_AgeEquivalent <NA>
    #>   ParticipantInfo
    #> 1            <2;0
    #> 2            <2;0
    #> 
    #> $VerbalFluency_Score
    #>        Study ParticipantID            Variable DIRT ParticipantInfo
    #> 1 TimePoint1          627L VerbalFluency_Score   NA               0
    #> 2 TimePoint1          635L VerbalFluency_Score   NA               0
