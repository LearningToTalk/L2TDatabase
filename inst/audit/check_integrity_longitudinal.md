Longitudinal Data Integrity Check
================
Tristan Mahr
2016-06-03

In Spring 2015, we had our data-entry team re-enter test scores gathered in the longitudinal study, so that we could find data-entry discrepancies. This script compares the original to the re-entered scores.

Participant pool comparison
---------------------------

Do the same participants contribute scores in each set?

Participants in original score-set ("ParticipantInfo") *not in* the re-entered score-set ("DIRT"):

    #> Source: local data frame [10 x 4]
    #> 
    #>         Study ParticipantID  DIRT ParticipantInfo
    #>         (chr)         (chr) (lgl)           (lgl)
    #> 1  TimePoint1          048L    NA            TRUE
    #> 2  TimePoint1          059L    NA            TRUE
    #> 3  TimePoint1          060L    NA            TRUE
    #> 4  TimePoint1          070L    NA            TRUE
    #> 5  TimePoint1          091L    NA            TRUE
    #> 6  TimePoint1          102L    NA            TRUE
    #> 7  TimePoint1          105L    NA            TRUE
    #> 8  TimePoint1          115L    NA            TRUE
    #> 9  TimePoint1          120L    NA            TRUE
    #> 10 TimePoint2          635L    NA            TRUE

Participants in re-entered score-set ("DIRT") *not in* the original score-set ("ParticipantInfo"):

    #> Source: local data frame [20 x 4]
    #> 
    #>         Study    ParticipantID  DIRT ParticipantInfo
    #>         (chr)            (chr) (lgl)           (lgl)
    #> 1  TimePoint1             648L  TRUE              NA
    #> 2  TimePoint1             662L  TRUE              NA
    #> 3  TimePoint1             672L  TRUE              NA
    #> 4  TimePoint1             687L  TRUE              NA
    #> 5  TimePoint2             003L  TRUE              NA
    #> 6  TimePoint2             013L  TRUE              NA
    #> 7  TimePoint2             054L  TRUE              NA
    #> 8  TimePoint2             059L  TRUE              NA
    #> 9  TimePoint2             060L  TRUE              NA
    #> 10 TimePoint2             062L  TRUE              NA
    #> 11 TimePoint2             073L  TRUE              NA
    #> 12 TimePoint2             079L  TRUE              NA
    #> 13 TimePoint2             091L  TRUE              NA
    #> 14 TimePoint2             102L  TRUE              NA
    #> 15 TimePoint2             105L  TRUE              NA
    #> 16 TimePoint2             115L  TRUE              NA
    #> 17 TimePoint2             120L  TRUE              NA
    #> 18 TimePoint2             131L  TRUE              NA
    #> 19 TimePoint2             132L  TRUE              NA
    #> 20 TimePoint2 635L (no folder)  TRUE              NA

Value Comparison
----------------

We now compare the scores in each score-set. This check is only being performed on participants in both score-sets.

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
    #> 1  TimePoint1          624L EVT_Form    A            <NA>
    #> 2  TimePoint3          607L EVT_Form    A            <NA>
    #> 3  TimePoint3          608L EVT_Form    A            <NA>
    #> 4  TimePoint3          609L EVT_Form    A            <NA>
    #> 5  TimePoint3          610L EVT_Form    A            <NA>
    #> 6  TimePoint3          611L EVT_Form    A            <NA>
    #> 7  TimePoint3          612L EVT_Form    A            <NA>
    #> 8  TimePoint3          614L EVT_Form    A            <NA>
    #> 9  TimePoint3          615L EVT_Form    A            <NA>
    #> 10 TimePoint3          616L EVT_Form    A            <NA>
    #> 11 TimePoint3          619L EVT_Form    A            <NA>
    #> 12 TimePoint3          620L EVT_Form    A            <NA>
    #> 13 TimePoint3          622L EVT_Form    A            <NA>
    #> 14 TimePoint3          623L EVT_Form    A            <NA>
    #> 15 TimePoint3          624L EVT_Form    A            <NA>
    #> 16 TimePoint3          625L EVT_Form    A            <NA>
    #> 17 TimePoint3          627L EVT_Form    A            <NA>
    #> 18 TimePoint3          628L EVT_Form    A            <NA>
    #> 19 TimePoint3          629L EVT_Form    A            <NA>
    #> 20 TimePoint3          630L EVT_Form    A            <NA>
    #> 21 TimePoint3          631L EVT_Form    A            <NA>
    #> 22 TimePoint3          632L EVT_Form    A            <NA>
    #> 23 TimePoint3          636L EVT_Form    A            <NA>
    #> 24 TimePoint3          638L EVT_Form    A            <NA>
    #> 25 TimePoint3          639L EVT_Form    A            <NA>
    #> 26 TimePoint3          640L EVT_Form    A            <NA>
    #> 27 TimePoint3          644L EVT_Form    A            <NA>
    #> 28 TimePoint3          651L EVT_Form    A            <NA>
    #> 29 TimePoint3          652L EVT_Form    A            <NA>
    #> 30 TimePoint3          655L EVT_Form    A            <NA>
    #> 31 TimePoint3          656L EVT_Form    A            <NA>
    #> 32 TimePoint3          657L EVT_Form    A            <NA>
    #> 33 TimePoint3          658L EVT_Form    A            <NA>
    #> 34 TimePoint3          659L EVT_Form    A            <NA>
    #> 35 TimePoint3          660L EVT_Form    A            <NA>
    #> 36 TimePoint3          661L EVT_Form    A            <NA>
    #> 37 TimePoint3          664L EVT_Form    A            <NA>
    #> 38 TimePoint3          665L EVT_Form    A            <NA>
    #> 39 TimePoint3          666L EVT_Form    A            <NA>
    #> 40 TimePoint3          667L EVT_Form    A            <NA>
    #> 41 TimePoint3          668L EVT_Form    A            <NA>
    #> 42 TimePoint3          669L EVT_Form    A            <NA>
    #> 43 TimePoint3          670L EVT_Form    A            <NA>
    #> 44 TimePoint3          671L EVT_Form    A            <NA>
    #> 45 TimePoint3          673L EVT_Form    A            <NA>
    #> 46 TimePoint3          674L EVT_Form    A            <NA>
    #> 47 TimePoint3          677L EVT_Form    A            <NA>
    #> 48 TimePoint3          678L EVT_Form    A            <NA>
    #> 49 TimePoint3          679L EVT_Form    A            <NA>
    #> 50 TimePoint3          680L EVT_Form    A            <NA>
    #> 51 TimePoint3          681L EVT_Form    A            <NA>
    #> 52 TimePoint3          683L EVT_Form    A            <NA>
    #> 53 TimePoint3          684L EVT_Form    A            <NA>
    #> 54 TimePoint3          685L EVT_Form    A            <NA>
    #> 55 TimePoint3          686L EVT_Form    A            <NA>
    #> 56 TimePoint3          689L EVT_Form    A            <NA>
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
    #>          Study ParticipantID  Variable       DIRT ParticipantInfo
    #> 1   TimePoint3          001L GFTA_Date 2015-08-04            <NA>
    #> 2   TimePoint3          002L GFTA_Date 2014-11-15            <NA>
    #> 3   TimePoint3          003L GFTA_Date 2014-10-08            <NA>
    #> 4   TimePoint3          004L GFTA_Date 2014-12-04            <NA>
    #> 5   TimePoint3          005L GFTA_Date 2014-11-14            <NA>
    #> 6   TimePoint3          006L GFTA_Date 2015-02-10            <NA>
    #> 7   TimePoint3          007L GFTA_Date 2014-11-21            <NA>
    #> 8   TimePoint3          008L GFTA_Date 2014-11-21            <NA>
    #> 9   TimePoint3          010L GFTA_Date 2014-12-15            <NA>
    #> 10  TimePoint3          011L GFTA_Date 2015-02-09            <NA>
    #> 11  TimePoint3          012L GFTA_Date 2015-01-29            <NA>
    #> 12  TimePoint3          014L GFTA_Date 2015-02-18            <NA>
    #> 13  TimePoint3          015L GFTA_Date 2014-12-15            <NA>
    #> 14  TimePoint3          016L GFTA_Date 2015-03-09            <NA>
    #> 15  TimePoint3          018L GFTA_Date 2015-02-28            <NA>
    #> 16  TimePoint3          019L GFTA_Date 2015-02-22            <NA>
    #> 17  TimePoint3          020L GFTA_Date 2015-02-22            <NA>
    #> 18  TimePoint3          021L GFTA_Date 2015-04-05            <NA>
    #> 19  TimePoint3          024L GFTA_Date 2015-04-08            <NA>
    #> 20  TimePoint3          025L GFTA_Date 2015-07-08            <NA>
    #> 21  TimePoint3          026L GFTA_Date 2015-03-27            <NA>
    #> 22  TimePoint3          027L GFTA_Date 2015-03-04            <NA>
    #> 23  TimePoint3          029L GFTA_Date 2015-05-20            <NA>
    #> 24  TimePoint3          030L GFTA_Date 2015-03-31            <NA>
    #> 25  TimePoint3          031L GFTA_Date 2015-07-21            <NA>
    #> 26  TimePoint3          032L GFTA_Date 2015-04-24            <NA>
    #> 27  TimePoint3          033L GFTA_Date 2015-05-28            <NA>
    #> 28  TimePoint3          034L GFTA_Date 2015-04-13            <NA>
    #> 29  TimePoint3          035L GFTA_Date 2015-07-11            <NA>
    #> 30  TimePoint3          037L GFTA_Date 2015-05-27            <NA>
    #> 31  TimePoint3          038L GFTA_Date 2015-09-12            <NA>
    #> 32  TimePoint3          039L GFTA_Date 2015-07-02            <NA>
    #> 33  TimePoint3          040L GFTA_Date 2015-05-09            <NA>
    #> 34  TimePoint3          041L GFTA_Date 2015-06-09            <NA>
    #> 35  TimePoint3          042L GFTA_Date 2015-06-09            <NA>
    #> 36  TimePoint3          043L GFTA_Date 2015-06-22            <NA>
    #> 37  TimePoint3          044L GFTA_Date 2016-01-25            <NA>
    #> 38  TimePoint3          046L GFTA_Date 2015-04-15            <NA>
    #> 39  TimePoint3          049L GFTA_Date 2015-08-17            <NA>
    #> 40  TimePoint3          050L GFTA_Date 2015-11-18            <NA>
    #> 41  TimePoint3          051L GFTA_Date 2016-01-07            <NA>
    #> 42  TimePoint3          052L GFTA_Date 2015-05-13            <NA>
    #> 43  TimePoint3          053L GFTA_Date 2016-01-15            <NA>
    #> 44  TimePoint3          055L GFTA_Date 2015-11-19            <NA>
    #> 45  TimePoint3          056L GFTA_Date 2015-09-19            <NA>
    #> 46  TimePoint3          057L GFTA_Date 2015-07-03            <NA>
    #> 47  TimePoint3          058L GFTA_Date 2015-07-25            <NA>
    #> 48  TimePoint3          061L GFTA_Date 2015-07-14            <NA>
    #> 49  TimePoint3          063L GFTA_Date 2015-07-28            <NA>
    #> 50  TimePoint3          064L GFTA_Date 2015-08-12            <NA>
    #> 51  TimePoint3          065L GFTA_Date 2015-07-15            <NA>
    #> 52  TimePoint3          066L GFTA_Date 2015-06-30            <NA>
    #> 53  TimePoint3          068L GFTA_Date 2015-06-25            <NA>
    #> 54  TimePoint3          069L GFTA_Date 2015-07-22            <NA>
    #> 55  TimePoint3          071L GFTA_Date 2015-08-03            <NA>
    #> 56  TimePoint3          072L GFTA_Date 2015-08-24            <NA>
    #> 57  TimePoint3          074L GFTA_Date 2015-08-17            <NA>
    #> 58  TimePoint3          075L GFTA_Date 2015-09-04            <NA>
    #> 59  TimePoint3          076L GFTA_Date 2016-01-11            <NA>
    #> 60  TimePoint3          077L GFTA_Date 2015-09-28            <NA>
    #> 61  TimePoint3          078L GFTA_Date 2016-01-22            <NA>
    #> 62  TimePoint3          080L GFTA_Date 2015-09-28            <NA>
    #> 63  TimePoint3          081L GFTA_Date 2015-09-29            <NA>
    #> 64  TimePoint3          082L GFTA_Date 2015-11-23            <NA>
    #> 65  TimePoint3          083L GFTA_Date 2016-01-13            <NA>
    #> 66  TimePoint3          085L GFTA_Date 2015-11-04            <NA>
    #> 67  TimePoint3          087L GFTA_Date 2015-10-27            <NA>
    #> 68  TimePoint3          088L GFTA_Date 2015-10-02            <NA>
    #> 69  TimePoint3          090L GFTA_Date 2015-11-19            <NA>
    #> 70  TimePoint3          092L GFTA_Date 2015-10-22            <NA>
    #> 71  TimePoint3          093L GFTA_Date 2015-11-23            <NA>
    #> 72  TimePoint3          094L GFTA_Date 2015-11-23            <NA>
    #> 73  TimePoint3          095L GFTA_Date 2015-11-09            <NA>
    #> 74  TimePoint3          096L GFTA_Date 2015-11-09            <NA>
    #> 75  TimePoint3          097L GFTA_Date 2015-12-05            <NA>
    #> 76  TimePoint3          098L GFTA_Date 2015-12-05            <NA>
    #> 77  TimePoint3          099L GFTA_Date 2015-11-14            <NA>
    #> 78  TimePoint3          100L GFTA_Date 2015-11-17            <NA>
    #> 79  TimePoint3          101L GFTA_Date 2015-11-17            <NA>
    #> 80  TimePoint3          104L GFTA_Date 2015-11-20            <NA>
    #> 81  TimePoint3          106L GFTA_Date 2015-11-20            <NA>
    #> 82  TimePoint3          107L GFTA_Date 2016-01-09            <NA>
    #> 83  TimePoint3          108L GFTA_Date 2016-02-15            <NA>
    #> 84  TimePoint3          109L GFTA_Date 2015-12-17            <NA>
    #> 85  TimePoint3          110L GFTA_Date 2016-01-19            <NA>
    #> 86  TimePoint3          111L GFTA_Date 2016-01-12            <NA>
    #> 87  TimePoint3          112L GFTA_Date 2015-12-17            <NA>
    #> 88  TimePoint3          113L GFTA_Date 2015-12-22            <NA>
    #> 89  TimePoint3          114L GFTA_Date 2015-12-19            <NA>
    #> 90  TimePoint3          117L GFTA_Date 2015-12-22            <NA>
    #> 91  TimePoint3          118L GFTA_Date 2015-12-21            <NA>
    #> 92  TimePoint3          119L GFTA_Date 2015-12-21            <NA>
    #> 93  TimePoint3          121L GFTA_Date 2015-12-30            <NA>
    #> 94  TimePoint3          122L GFTA_Date 2015-12-30            <NA>
    #> 95  TimePoint3          124L GFTA_Date 2016-01-13            <NA>
    #> 96  TimePoint3          126L GFTA_Date 2016-02-09            <NA>
    #> 97  TimePoint3          127L GFTA_Date 2016-01-15            <NA>
    #> 98  TimePoint3          128L GFTA_Date 2016-01-29            <NA>
    #> 99  TimePoint3          129L GFTA_Date 2016-03-06            <NA>
    #> 100 TimePoint3          130L GFTA_Date 2016-03-06            <NA>
    #> 101 TimePoint3          131L GFTA_Date 2016-02-13            <NA>
    #> 102 TimePoint3          133L GFTA_Date 2016-02-03            <NA>
    #> 103 TimePoint3          600L GFTA_Date 2014-12-12            <NA>
    #> 104 TimePoint3          602L GFTA_Date 2014-12-18            <NA>
    #> 105 TimePoint3          604L GFTA_Date 2014-12-23            <NA>
    #> 106 TimePoint3          605L GFTA_Date 2014-11-15            <NA>
    #> 107 TimePoint3          607L GFTA_Date 2014-12-16            <NA>
    #> 108 TimePoint3          609L GFTA_Date 2014-12-12            <NA>
    #> 109 TimePoint3          610L GFTA_Date 2014-11-21            <NA>
    #> 110 TimePoint3          611L GFTA_Date 2015-03-27            <NA>
    #> 111 TimePoint3          612L GFTA_Date 2015-01-26            <NA>
    #> 112 TimePoint3          614L GFTA_Date 2015-01-05            <NA>
    #> 113 TimePoint3          615L GFTA_Date 2015-05-21            <NA>
    #> 114 TimePoint3          616L GFTA_Date 2015-02-07            <NA>
    #> 115 TimePoint3          619L GFTA_Date 2015-02-28            <NA>
    #> 116 TimePoint3          620L GFTA_Date 2015-01-23            <NA>
    #> 117 TimePoint3          622L GFTA_Date 2015-03-12            <NA>
    #> 118 TimePoint3          623L GFTA_Date 2015-02-27            <NA>
    #> 119 TimePoint3          624L GFTA_Date 2015-03-06            <NA>
    #> 120 TimePoint3          625L GFTA_Date 2015-03-24            <NA>
    #> 121 TimePoint3          627L GFTA_Date 2015-02-07            <NA>
    #> 122 TimePoint3          628L GFTA_Date 2015-04-30            <NA>
    #> 123 TimePoint3          629L GFTA_Date 2015-05-08            <NA>
    #> 124 TimePoint3          630L GFTA_Date 2016-01-19            <NA>
    #> 125 TimePoint3          631L GFTA_Date 2015-06-13            <NA>
    #> 126 TimePoint3          632L GFTA_Date 2015-05-02            <NA>
    #> 127 TimePoint3          636L GFTA_Date 2015-05-11            <NA>
    #> 128 TimePoint3          638L GFTA_Date 2015-06-10            <NA>
    #> 129 TimePoint3          639L GFTA_Date 2015-06-09            <NA>
    #> 130 TimePoint3          640L GFTA_Date 2015-06-13            <NA>
    #> 131 TimePoint3          644L GFTA_Date 2015-08-21            <NA>
    #> 132 TimePoint3          651L GFTA_Date 2015-11-07            <NA>
    #> 133 TimePoint3          652L GFTA_Date 2015-07-30            <NA>
    #> 134 TimePoint3          655L GFTA_Date 2015-12-18            <NA>
    #> 135 TimePoint3          656L GFTA_Date 2015-07-27            <NA>
    #> 136 TimePoint3          657L GFTA_Date 2015-09-25            <NA>
    #> 137 TimePoint3          658L GFTA_Date 2015-09-01            <NA>
    #> 138 TimePoint3          659L GFTA_Date 2015-09-11            <NA>
    #> 139 TimePoint3          660L GFTA_Date 2015-11-14            <NA>
    #> 140 TimePoint3          661L GFTA_Date 2015-11-06            <NA>
    #> 141 TimePoint3          664L GFTA_Date 2015-11-11            <NA>
    #> 142 TimePoint3          665L GFTA_Date 2015-11-21            <NA>
    #> 143 TimePoint3          666L GFTA_Date 2015-10-08            <NA>
    #> 144 TimePoint3          667L GFTA_Date 2015-10-24            <NA>
    #> 145 TimePoint3          668L GFTA_Date 2015-10-10            <NA>
    #> 146 TimePoint3          669L GFTA_Date 2015-10-09            <NA>
    #> 147 TimePoint3          670L GFTA_Date 2015-09-25            <NA>
    #> 148 TimePoint3          671L GFTA_Date 2015-12-12            <NA>
    #> 149 TimePoint3          673L GFTA_Date 2015-12-19            <NA>
    #> 150 TimePoint3          674L GFTA_Date 2015-12-04            <NA>
    #> 151 TimePoint3          677L GFTA_Date 2016-01-05            <NA>
    #> 152 TimePoint3          678L GFTA_Date 2016-02-19            <NA>
    #> 153 TimePoint3          679L GFTA_Date 2016-03-09            <NA>
    #> 154 TimePoint3          680L GFTA_Date 2015-12-17            <NA>
    #> 155 TimePoint3          681L GFTA_Date 2016-02-09            <NA>
    #> 156 TimePoint3          683L GFTA_Date 2016-02-26            <NA>
    #> 157 TimePoint3          684L GFTA_Date 2016-01-30            <NA>
    #> 158 TimePoint3          685L GFTA_Date 2016-02-20            <NA>
    #> 159 TimePoint3          686L GFTA_Date 2016-02-20            <NA>
    #> 160 TimePoint3          689L GFTA_Date 2016-03-01            <NA>
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
    #> 1  TimePoint1          606L PPVT_Form          A            <NA>
    #> 2  TimePoint1          631L PPVT_Form       <NA>               A
    #> 3  TimePoint1          635L PPVT_Form       <NA>               A
    #> 4  TimePoint3          089L PPVT_Form          A            <NA>
    #> 5  TimePoint3          608L PPVT_Form          A            <NA>
    #> 6  TimePoint3          609L PPVT_Form          A            <NA>
    #> 7  TimePoint3          631L PPVT_Form          A            <NA>
    #> 8  TimePoint3          638L PPVT_Form          A            <NA>
    #> 9  TimePoint3          660L PPVT_Form 2015-11-14            <NA>
    #> 10 TimePoint3          665L PPVT_Form          A            <NA>
    #> 11 TimePoint3          666L PPVT_Form          A            <NA>
    #> 12 TimePoint3          671L PPVT_Form          A            <NA>
    #> 13 TimePoint3          677L PPVT_Form          A            <NA>
    #> 14 TimePoint3          679L PPVT_Form          A            <NA>
    #> 15 TimePoint3          680L PPVT_Form          A            <NA>
    #> 16 TimePoint3          681L PPVT_Form          A            <NA>
    #> 17 TimePoint3          684L PPVT_Form          A            <NA>
    #> 18 TimePoint3          685L PPVT_Form          A            <NA>
    #> 19 TimePoint3          686L PPVT_Form          A            <NA>
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
