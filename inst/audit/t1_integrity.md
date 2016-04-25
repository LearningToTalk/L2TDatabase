TP1 Data Integrity Check
================
Tristan Mahr
2016-04-25

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

    #>  [1] "<2;0" "2;1"  "2;10" "2;3"  "2;5"  "2;7"  "2;8"  "3;0"  "3;1"  "3;3" 
    #> [11] "3;4"  "3;6"  "3;7"  "3;9"  "4;10"

Some of those values used to have leading spaces. These are the rows with spaces located in the score. (Empty is good.)

    #> Source: local data frame [0 x 3]
    #> 
    #> Variables not shown: ParticipantID (chr), Source (chr),
    #>   VerbalFluency_AgeEquivalent (chr)

These are the unique values found in the re-entry score-set.

    #>  [1] "<2;0" "2;1"  "2;10" "2;3"  "2;5"  "2;7"  "2;8"  "3;0"  "3;1"  "3;3" 
    #> [11] "3;4"  "3;6"  "3;7"  "3;9"  "4;10"

We used to write chronological ages as "Year-Month" but have since switched to "Year;Month", so we still check for these hyphens. (Empty is good.)

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
    #>   ParticipantID Variable DIRT ParticipantInfo
    #> 1          057L  EVT_GSV  121             118
    #> 2          058L  EVT_GSV  118             121
    #> 3          084L  EVT_GSV  108             107
    #> 4          616L  EVT_GSV   NA             104
    #> 5          619L  EVT_GSV  118             123
    #> 6          622L  EVT_GSV   NA             122
    #> 7          631L  EVT_GSV   NA             102
    #> 8          657L  EVT_GSV   NA             121
    #> 
    #> $EVT_Raw
    #>   ParticipantID Variable DIRT ParticipantInfo
    #> 1          057L  EVT_Raw   43              40
    #> 2          058L  EVT_Raw   40              43
    #> 3          616L  EVT_Raw   NA              24
    #> 4          622L  EVT_Raw   NA              44
    #> 
    #> $EVT_Standard
    #>   ParticipantID     Variable DIRT ParticipantInfo
    #> 1          057L EVT_Standard  113             114
    #> 2          058L EVT_Standard  114             113
    #> 3          616L EVT_Standard   NA             102
    #> 4          622L EVT_Standard   NA             129
    #> 5          631L EVT_Standard   NA              99
    #> 6          657L EVT_Standard   NA             128
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
    #>   ParticipantID Variable DIRT ParticipantInfo
    #> 1          057L PPVT_GSV  109             105
    #> 2          058L PPVT_GSV  105             109
    #> 3          631L PPVT_GSV   NA              70
    #> 4          657L PPVT_GSV   NA              90
    #> 5          661L PPVT_GSV   NA             110
    #> 6          671L PPVT_GSV   98              97
    #> 
    #> $PPVT_Raw
    #>   ParticipantID Variable DIRT ParticipantInfo
    #> 1          057L PPVT_Raw   56              51
    #> 2          058L PPVT_Raw   51              56
    #> 
    #> $PPVT_Standard
    #>   ParticipantID      Variable DIRT ParticipantInfo
    #> 1          057L PPVT_Standard  110             106
    #> 2          058L PPVT_Standard  106             110
    #> 3          118L PPVT_Standard 1121             111
    #> 4          628L PPVT_Standard  119             116
    #> 5          631L PPVT_Standard   NA              84
    #> 6          657L PPVT_Standard   NA             101
    #> 7          661L PPVT_Standard   NA             122
    #> 
    #> $VerbalFluency_AgeEquivalent
    #>   ParticipantID                    Variable DIRT ParticipantInfo
    #> 1          619L VerbalFluency_AgeEquivalent  2;3             2;5
    #> 2          627L VerbalFluency_AgeEquivalent <NA>            <2;0
    #> 3          632L VerbalFluency_AgeEquivalent <2;0             2;7
    #> 4          635L VerbalFluency_AgeEquivalent <NA>            <2;0
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
