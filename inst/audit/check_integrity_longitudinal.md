Longitudinal Data Integrity Check
================
Tristan Mahr
2016-06-27

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

    #> Source: local data frame [0 x 4]
    #> 
    #> Variables not shown: Study <chr>, ParticipantID <chr>, DIRT <lgl>,
    #>   ParticipantInfo <lgl>.

Value Comparison
----------------

We now compare the scores in each score-set. This check is only being performed on participants in both score-sets.

### Unchecked fields

The following columns in DIRT are not being checked because there is not a matching column in the participant info spreadsheets

| Variable                |                  |
|:------------------------|------------------|
| VerbalFluency\_Date     | :grey\_question: |
| FruitStroop\_Date       | :grey\_question: |
| MBCDI\_Date             | :grey\_question: |
| CDI\_Extension\_Date    | :grey\_question: |
| BRIEFP\_Date            | :grey\_question: |
| CTOPPElision\_Date      | :grey\_question: |
| CTOPPBlending\_Date     | :grey\_question: |
| KBIT\_Date              | :grey\_question: |
| DELV\_LanguageVar       | :grey\_question: |
| DELV\_DegreeLanguageVar | :grey\_question: |

### Summary

This table lists all the fields that were checked and whether any discrepancies were found in that field.

| Variable                                 | Passing |                      |
|:-----------------------------------------|:--------|----------------------|
| CTOPPBlending\_Raw                       | TRUE    | :white\_check\_mark: |
| CTOPPBlending\_Scaled                    | TRUE    | :white\_check\_mark: |
| CTOPPElision\_Raw                        | TRUE    | :white\_check\_mark: |
| CTOPPElision\_Scaled                     | TRUE    | :white\_check\_mark: |
| CTOPPMemory\_Date                        | TRUE    | :white\_check\_mark: |
| CTOPPMemory\_Raw                         | TRUE    | :white\_check\_mark: |
| CTOPPMemory\_Scaled                      | TRUE    | :white\_check\_mark: |
| DELV\_Date                               | FALSE   | :x:                  |
| DELV\_LanguageRisk                       | TRUE    | :white\_check\_mark: |
| DELV\_LanguageRisk\_DiagnosticErrorScore | TRUE    | :white\_check\_mark: |
| DELV\_LanguageVar\_ColumnAScore          | TRUE    | :white\_check\_mark: |
| DELV\_LanguageVar\_ColumnBScore          | TRUE    | :white\_check\_mark: |
| EVT\_Date                                | TRUE    | :white\_check\_mark: |
| EVT\_Form                                | TRUE    | :white\_check\_mark: |
| EVT\_GSV                                 | TRUE    | :white\_check\_mark: |
| EVT\_Raw                                 | TRUE    | :white\_check\_mark: |
| EVT\_Standard                            | TRUE    | :white\_check\_mark: |
| FruitStroop\_Score                       | TRUE    | :white\_check\_mark: |
| GFTA\_Date                               | FALSE   | :x:                  |
| KBIT\_Raw                                | TRUE    | :white\_check\_mark: |
| KBIT\_Standard                           | TRUE    | :white\_check\_mark: |
| PPVT\_Date                               | FALSE   | :x:                  |
| PPVT\_Form                               | TRUE    | :white\_check\_mark: |
| PPVT\_GSV                                | FALSE   | :x:                  |
| PPVT\_Raw                                | FALSE   | :x:                  |
| PPVT\_Standard                           | FALSE   | :x:                  |
| VerbalFluency\_AgeEquivalent             | TRUE    | :white\_check\_mark: |
| VerbalFluency\_Score                     | TRUE    | :white\_check\_mark: |

### Details

These are all the mismatching values.

    #> $DELV_Date
    #>        Study ParticipantID  Variable       DIRT ParticipantInfo
    #> 1 TimePoint3          685L DELV_Date 2016-03-12            <NA>
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
    #> 11 TimePoint3          600L GFTA_Date 2014-12-12            <NA>
    #> 12 TimePoint3          602L GFTA_Date 2014-12-18            <NA>
    #> 13 TimePoint3          604L GFTA_Date 2014-12-23            <NA>
    #> 14 TimePoint3          605L GFTA_Date 2014-11-15            <NA>
    #> 15 TimePoint3          607L GFTA_Date 2014-12-16            <NA>
    #> 16 TimePoint3          608L GFTA_Date 2014-12-30            <NA>
    #> 17 TimePoint3          609L GFTA_Date 2014-12-12            <NA>
    #> 18 TimePoint3          610L GFTA_Date 2014-11-21            <NA>
    #> 19 TimePoint3          611L GFTA_Date 2015-03-27            <NA>
    #> 20 TimePoint3          612L GFTA_Date 2015-01-26            <NA>
    #> 21 TimePoint3          614L GFTA_Date 2015-01-05            <NA>
    #> 22 TimePoint3          615L GFTA_Date 2015-05-21            <NA>
    #> 23 TimePoint3          616L GFTA_Date 2015-02-07            <NA>
    #> 24 TimePoint3          619L GFTA_Date 2015-02-28            <NA>
    #> 25 TimePoint3          620L GFTA_Date 2015-01-23            <NA>
    #> 26 TimePoint3          622L GFTA_Date 2015-03-12            <NA>
    #> 27 TimePoint3          623L GFTA_Date 2015-02-27            <NA>
    #> 28 TimePoint3          624L GFTA_Date 2015-03-06            <NA>
    #> 29 TimePoint3          625L GFTA_Date 2015-03-24            <NA>
    #> 30 TimePoint3          627L GFTA_Date 2015-02-07            <NA>
    #> 31 TimePoint3          628L GFTA_Date 2015-04-30            <NA>
    #> 32 TimePoint3          629L GFTA_Date 2015-05-08            <NA>
    #> 33 TimePoint3          630L GFTA_Date 2016-01-19            <NA>
    #> 34 TimePoint3          631L GFTA_Date 2015-06-13            <NA>
    #> 35 TimePoint3          632L GFTA_Date 2015-05-02            <NA>
    #> 36 TimePoint3          636L GFTA_Date 2015-05-11            <NA>
    #> 37 TimePoint3          638L GFTA_Date 2015-06-10            <NA>
    #> 38 TimePoint3          639L GFTA_Date 2015-06-09            <NA>
    #> 39 TimePoint3          640L GFTA_Date 2015-06-13            <NA>
    #> 40 TimePoint3          644L GFTA_Date 2015-08-21            <NA>
    #> 41 TimePoint3          651L GFTA_Date 2015-11-07            <NA>
    #> 42 TimePoint3          652L GFTA_Date 2015-07-30            <NA>
    #> 43 TimePoint3          655L GFTA_Date 2015-12-18            <NA>
    #> 44 TimePoint3          656L GFTA_Date 2015-07-27            <NA>
    #> 45 TimePoint3          657L GFTA_Date 2015-09-25            <NA>
    #> 46 TimePoint3          658L GFTA_Date 2015-09-01            <NA>
    #> 47 TimePoint3          659L GFTA_Date 2015-09-11            <NA>
    #> 48 TimePoint3          660L GFTA_Date 2015-11-14            <NA>
    #> 49 TimePoint3          661L GFTA_Date 2015-11-06            <NA>
    #> 50 TimePoint3          664L GFTA_Date 2015-11-11            <NA>
    #> 51 TimePoint3          665L GFTA_Date 2015-11-21            <NA>
    #> 52 TimePoint3          666L GFTA_Date 2015-10-08            <NA>
    #> 53 TimePoint3          667L GFTA_Date 2015-10-24            <NA>
    #> 54 TimePoint3          668L GFTA_Date 2015-10-10            <NA>
    #> 55 TimePoint3          669L GFTA_Date 2015-10-09            <NA>
    #> 56 TimePoint3          670L GFTA_Date 2015-09-25            <NA>
    #> 57 TimePoint3          671L GFTA_Date 2015-12-12            <NA>
    #> 58 TimePoint3          673L GFTA_Date 2015-12-19            <NA>
    #> 59 TimePoint3          674L GFTA_Date 2015-12-04            <NA>
    #> 60 TimePoint3          677L GFTA_Date 2016-01-05            <NA>
    #> 61 TimePoint3          678L GFTA_Date 2016-02-19            <NA>
    #> 62 TimePoint3          679L GFTA_Date 2016-03-09            <NA>
    #> 63 TimePoint3          680L GFTA_Date 2015-12-17            <NA>
    #> 64 TimePoint3          681L GFTA_Date 2016-02-09            <NA>
    #> 65 TimePoint3          683L GFTA_Date 2016-02-26            <NA>
    #> 66 TimePoint3          684L GFTA_Date 2016-01-30            <NA>
    #> 67 TimePoint3          685L GFTA_Date 2016-02-20            <NA>
    #> 68 TimePoint3          686L GFTA_Date 2016-02-20            <NA>
    #> 69 TimePoint3          689L GFTA_Date 2016-03-01            <NA>
    #> 
    #> $PPVT_Date
    #>        Study ParticipantID  Variable       DIRT ParticipantInfo
    #> 1 TimePoint1          635L PPVT_Date 2013-06-17            <NA>
    #> 
    #> $PPVT_GSV
    #>        Study ParticipantID Variable DIRT ParticipantInfo
    #> 1 TimePoint1          635L PPVT_GSV   82              NA
    #> 
    #> $PPVT_Raw
    #>        Study ParticipantID Variable DIRT ParticipantInfo
    #> 1 TimePoint1          635L PPVT_Raw   26              NA
    #> 
    #> $PPVT_Standard
    #>        Study ParticipantID      Variable DIRT ParticipantInfo
    #> 1 TimePoint1          635L PPVT_Standard   94              NA
