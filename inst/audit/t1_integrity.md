TP1 Data Integrity Check
================
Tristan Mahr
2016-03-16

In Spring 2015, we had our data-entry team re-enter test scores gathered in the longitudinal study, so that we could find data-entry discrepancies. This script compares the original to the re-entered scores.

Participant pool comparison
---------------------------

Do the same participants contribute scores in each set?

Participants in original score-set ("ParticipantInfo") *not in* the re-entered score-set ("DIRT"):

    #> Source: local data frame [9 x 2]
    #> 
    #>            Source ParticipantID
    #>             (chr)         (chr)
    #> 1 ParticipantInfo          048L
    #> 2 ParticipantInfo          059L
    #> 3 ParticipantInfo          060L
    #> 4 ParticipantInfo          070L
    #> 5 ParticipantInfo          091L
    #> 6 ParticipantInfo          102L
    #> 7 ParticipantInfo          105L
    #> 8 ParticipantInfo          115L
    #> 9 ParticipantInfo          120L

Participants in re-entered score-set ("DIRT") *not in* the original score-set ("ParticipantInfo"):

    #> Source: local data frame [4 x 2]
    #> 
    #>   Source ParticipantID
    #>    (chr)         (chr)
    #> 1   DIRT          648L
    #> 2   DIRT          662L
    #> 3   DIRT          672L
    #> 4   DIRT          687L

Verbal Fluency Value Formatting Comparison
------------------------------------------

The most fiddly field seems to be the Verbal Fluency age-equivalents score.

These are the unique values found in the original score-set.

    #>  [1] "                           <2;0" " <2;0"                          
    #>  [3] "<2-0"                            "<2;0"                           
    #>  [5] "2-1"                             "2-10"                           
    #>  [7] "2-3"                             "2-5"                            
    #>  [9] "2-7"                             "2-8"                            
    #> [11] "2;10"                            "2;3"                            
    #> [13] "2;8"                             "3-0"                            
    #> [15] "3-1"                             "3-3"                            
    #> [17] "3-6"                             "3-7"                            
    #> [19] "3-9"                             "3;0"                            
    #> [21] "3;3"                             "3;4"                            
    #> [23] "3;9"                             "4;10"

Some of those values have leading spaces. These are the rows with spaces located in the score:

    #> Source: local data frame [5 x 3]
    #> 
    #>   ParticipantID          Source     VerbalFluency_AgeEquivalent
    #>           (chr)           (chr)                           (chr)
    #> 1          025L ParticipantInfo                            <2;0
    #> 2          078L ParticipantInfo                            <2;0
    #> 3          079L ParticipantInfo                            <2;0
    #> 4          080L ParticipantInfo                            <2;0
    #> 5          084L ParticipantInfo                            <2;0

These are the unique values found in the re-entry score-set. We need to convert hyphens into semicolons.

    #>  [1] "<2;0" "2;0"  "2;1"  "2;10" "2;3"  "2;5"  "2;7"  "2;8"  "3;0"  "3;1" 
    #> [11] "3;3"  "3;4"  "3;6"  "3;7"  "3;9"  "4;10"

These are the rows in the re-entered score set with hyphens instead of semicolons (our preferred way to write "Year;Month" chronological ages).

    #> Source: local data frame [0 x 5]
    #> 
    #> Variables not shown: Site (chr), Study (chr), ParticipantID (chr),
    #>   Variable (chr), Value (chr)

Value Comparison
----------------

We now compare the scores in each score-set. This check is only being performed on participants in both score-sets.

    #> $EVT_Date
    #>   ParticipantID Variable       DIRT ParticipantInfo
    #> 1          045L EVT_Date 2013-09-19            <NA>
    #> 2          057L EVT_Date 2013-07-01      2013-07-13
    #> 3          058L EVT_Date 2013-07-13      2013-07-01
    #> 4          128L EVT_Date 2014-01-31      2014-01-21
    #> 5          602L EVT_Date 2012-11-27      2012-12-11
    #> 6          611L EVT_Date 2010-11-19      2012-11-19
    #> 7          629L EVT_Date 2013-05-17      2013-05-10
    #> 8          642L EVT_Date 2013-08-26      2013-08-20
    #> 9          688L EVT_Date 2014-03-08      2014-03-15
    #> 
    #> $EVT_Form
    #>   ParticipantID Variable DIRT ParticipantInfo
    #> 1          624L EVT_Form    A            <NA>
    #> 
    #> $EVT_GSV
    #>    ParticipantID Variable DIRT ParticipantInfo
    #> 1           057L  EVT_GSV  121             118
    #> 2           058L  EVT_GSV  118             121
    #> 3           084L  EVT_GSV  108             107
    #> 4           609L  EVT_GSV   NA              85
    #> 5           614L  EVT_GSV   NA             116
    #> 6           616L  EVT_GSV   NA             104
    #> 7           619L  EVT_GSV  118             123
    #> 8           620L  EVT_GSV   NA             127
    #> 9           622L  EVT_GSV   NA             122
    #> 10          631L  EVT_GSV   NA             102
    #> 11          636L  EVT_GSV   NA              97
    #> 12          654L  EVT_GSV   NA              90
    #> 13          657L  EVT_GSV   NA             121
    #> 14          658L  EVT_GSV   NA             133
    #> 15          660L  EVT_GSV   NA             114
    #> 16          661L  EVT_GSV   NA             115
    #> 17          682L  EVT_GSV   NA             122
    #> 18          685L  EVT_GSV   NA              54
    #> 19          686L  EVT_GSV   NA              70
    #> 
    #> $EVT_Raw
    #>   ParticipantID Variable DIRT ParticipantInfo
    #> 1          057L  EVT_Raw   43              40
    #> 2          058L  EVT_Raw   40              43
    #> 3          609L  EVT_Raw   NA              10
    #> 4          614L  EVT_Raw   NA              37
    #> 5          616L  EVT_Raw   NA              24
    #> 6          620L  EVT_Raw   NA              50
    #> 7          622L  EVT_Raw   NA              44
    #> 
    #> $EVT_Standard
    #>    ParticipantID     Variable DIRT ParticipantInfo
    #> 1           057L EVT_Standard  113             114
    #> 2           058L EVT_Standard  114             113
    #> 3           609L EVT_Standard   NA              84
    #> 4           614L EVT_Standard   NA             121
    #> 5           616L EVT_Standard   NA             102
    #> 6           620L EVT_Standard   NA             137
    #> 7           622L EVT_Standard   NA             129
    #> 8           631L EVT_Standard   NA              99
    #> 9           636L EVT_Standard   NA              95
    #> 10          654L EVT_Standard   NA              88
    #> 11          657L EVT_Standard   NA             128
    #> 12          658L EVT_Standard   NA             146
    #> 13          660L EVT_Standard   NA             118
    #> 14          661L EVT_Standard   NA             120
    #> 15          682L EVT_Standard   NA             129
    #> 16          685L EVT_Standard   NA              59
    #> 17          686L EVT_Standard   NA              72
    #> 
    #> $FruitStroop_Score
    #>   ParticipantID          Variable DIRT ParticipantInfo
    #> 1          006L FruitStroop_Score 1.20            1.22
    #> 2          046L FruitStroop_Score 2.10            2.11
    #> 3          057L FruitStroop_Score 2.78            2.11
    #> 4          058L FruitStroop_Score 2.11            2.78
    #> 5          601L FruitStroop_Score   NA            3.00
    #> 6          612L FruitStroop_Score 1.11            1.10
    #> 7          616L FruitStroop_Score 1.78            1.77
    #> 8          635L FruitStroop_Score   NA            2.00
    #> 9          657L FruitStroop_Score 1.88            1.89
    #> 
    #> $PPVT_Date
    #>   ParticipantID  Variable       DIRT ParticipantInfo
    #> 1          015L PPVT_Date       <NA>      2013-02-05
    #> 2          053L PPVT_Date 2013-02-11      2014-02-11
    #> 3          057L PPVT_Date 2013-07-22      2013-08-13
    #> 4          058L PPVT_Date 2013-08-13      2013-07-22
    #> 5          602L PPVT_Date 2012-12-18      2012-11-27
    #> 6          609L PPVT_Date 2010-12-12      2012-12-10
    #> 7          628L PPVT_Date 2013-05-08      2013-08-05
    #> 8          644L PPVT_Date 2013-10-08      2013-10-18
    #> 
    #> $PPVT_Form
    #>   ParticipantID  Variable DIRT ParticipantInfo
    #> 1          606L PPVT_Form    A            <NA>
    #> 2          631L PPVT_Form <NA>               A
    #> 3          635L PPVT_Form <NA>               A
    #> 
    #> $PPVT_GSV
    #>    ParticipantID Variable DIRT ParticipantInfo
    #> 1           057L PPVT_GSV  109             105
    #> 2           058L PPVT_GSV  105             109
    #> 3           609L PPVT_GSV   NA              90
    #> 4           614L PPVT_GSV   NA              89
    #> 5           620L PPVT_GSV   NA             116
    #> 6           631L PPVT_GSV   NA              70
    #> 7           654L PPVT_GSV   NA              79
    #> 8           657L PPVT_GSV   NA              90
    #> 9           660L PPVT_GSV   NA              70
    #> 10          661L PPVT_GSV   NA             110
    #> 11          671L PPVT_GSV   98              97
    #> 12          685L PPVT_GSV   NA              96
    #> 13          686L PPVT_GSV   NA              70
    #> 
    #> $PPVT_Raw
    #>   ParticipantID Variable DIRT ParticipantInfo
    #> 1          057L PPVT_Raw   56              51
    #> 2          058L PPVT_Raw   51              56
    #> 3          609L PPVT_Raw   NA              34
    #> 4          614L PPVT_Raw   NA              33
    #> 5          620L PPVT_Raw   NA              64
    #> 
    #> $PPVT_Standard
    #>    ParticipantID      Variable DIRT ParticipantInfo
    #> 1           057L PPVT_Standard  110             106
    #> 2           058L PPVT_Standard  106             110
    #> 3           118L PPVT_Standard 1121             111
    #> 4           609L PPVT_Standard   NA             101
    #> 5           614L PPVT_Standard   NA             100
    #> 6           620L PPVT_Standard   NA             129
    #> 7           628L PPVT_Standard  119             116
    #> 8           631L PPVT_Standard   NA              84
    #> 9           654L PPVT_Standard   NA              92
    #> 10          657L PPVT_Standard   NA             101
    #> 11          660L PPVT_Standard   NA              84
    #> 12          661L PPVT_Standard   NA             122
    #> 13          685L PPVT_Standard   NA             106
    #> 14          686L PPVT_Standard   NA              84
    #> 
    #> $VerbalFluency_AgeEquivalent
    #>    ParticipantID                    Variable DIRT ParticipantInfo
    #> 1           602L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 2           605L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 3           606L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 4           607L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 5           609L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 6           610L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 7           612L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 8           613L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 9           614L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 10          616L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 11          619L VerbalFluency_AgeEquivalent  2;3             2;5
    #> 12          620L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 13          622L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 14          624L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 15          627L VerbalFluency_AgeEquivalent <NA>            <2;0
    #> 16          629L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 17          630L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 18          631L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 19          632L VerbalFluency_AgeEquivalent  2;0             2;7
    #> 20          635L VerbalFluency_AgeEquivalent <NA>            <2;0
    #> 21          636L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 22          638L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 23          639L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 24          640L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 25          641L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 26          642L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 27          643L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 28          645L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 29          646L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 30          649L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 31          651L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 32          654L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 33          657L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 34          659L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 35          660L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 36          661L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 37          665L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 38          666L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 39          671L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 40          673L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 41          675L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 42          676L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 43          677L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 44          678L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 45          680L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 46          681L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 47          682L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 48          684L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 49          685L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 50          686L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 51          688L VerbalFluency_AgeEquivalent  2;0            <2;0
    #> 
    #> $VerbalFluency_Score
    #>   ParticipantID            Variable DIRT ParticipantInfo
    #> 1          057L VerbalFluency_Score    0               2
    #> 2          058L VerbalFluency_Score    2               0
    #> 3          619L VerbalFluency_Score    5               6
    #> 4          627L VerbalFluency_Score   NA               0
    #> 5          632L VerbalFluency_Score    0               7
    #> 6          635L VerbalFluency_Score   NA               0
    #> 7          657L VerbalFluency_Score    0               1
