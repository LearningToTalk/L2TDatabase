TP2 Data Integrity Check
================
Tristan Mahr
2016-05-18

In Spring 2015, we had our data-entry team re-enter test scores gathered in the longitudinal study, so that we could find data-entry discrepancies. This script compares the original to the re-entered scores.

Participant pool comparison
---------------------------

Do the same participants contribute scores in each set?

Participants in original score-set ("ParticipantInfo") *not in* the re-entered score-set ("DIRT"):

    #> Source: local data frame [1 x 2]
    #> 
    #>            Source ParticipantID
    #>             (chr)         (chr)
    #> 1 ParticipantInfo          635L

Participants in re-entered score-set ("DIRT") *not in* the original score-set ("ParticipantInfo"):

    #> Source: local data frame [16 x 2]
    #> 
    #>    Source    ParticipantID
    #>     (chr)            (chr)
    #> 1    DIRT             003L
    #> 2    DIRT             013L
    #> 3    DIRT             054L
    #> 4    DIRT             059L
    #> 5    DIRT             060L
    #> 6    DIRT             062L
    #> 7    DIRT             073L
    #> 8    DIRT             079L
    #> 9    DIRT             091L
    #> 10   DIRT             102L
    #> 11   DIRT             105L
    #> 12   DIRT             115L
    #> 13   DIRT             120L
    #> 14   DIRT             131L
    #> 15   DIRT             132L
    #> 16   DIRT 635L (no folder)

Verbal Fluency Value Formatting Comparison
------------------------------------------

The most fiddly field seems to be the Verbal Fluency age-equivalents score.

These are the unique values found in the original score-set.

    #>  [1] "<2;0" "2;1"  "2;10" "2;3"  "2;5"  "2;7"  "2;8"  "3;0"  "3;1"  "3;11"
    #> [11] "3;3"  "3;4"  "3;6"  "3;7"  "3;9"  "4;0"  "4;2"  "4;5"  "4;7"  "4;9" 
    #> [21] "5;2"  "5;5"  "5;7"  "6;8"

Some of those values used to have leading spaces. These are the rows with spaces located in the score. (Empty is good.)

    #> Source: local data frame [0 x 3]
    #> 
    #> Variables not shown: ParticipantID (chr), Source (chr),
    #>   VerbalFluency_AgeEquivalent (chr)

These are the unique values found in the re-entry score-set.

    #>  [1] "<2;0" "2;1"  "2;10" "2;3"  "2;3 " "2;5"  "2;7"  "2;8"  "3;0"  "3;1" 
    #> [11] "3;11" "3;3"  "3;4"  "3;6"  "3;7"  "3;9"  "4;0"  "4;2"  "4;5"  "4;7" 
    #> [21] "4;9"  "5;2"  "5;5"  "5;7"  "6;8"

We used to write chronological ages as "Year-Month" but have since switched to "Year;Month", so we still check for these hyphens. (Empty is good.)

    #> Source: local data frame [0 x 5]
    #> 
    #> Variables not shown: Site (chr), Study (chr), ParticipantID (chr),
    #>   Variable (chr), Value (chr)

Value Comparison
----------------

We now compare the scores in each score-set. This check is only being performed on participants in both score-sets.

    #> $CTOPPBlending_Raw
    #> [1] ParticipantID   Variable        DIRT            ParticipantInfo
    #> <0 rows> (or 0-length row.names)
    #> 
    #> $CTOPPBlending_Scaled
    #> [1] ParticipantID   Variable        DIRT            ParticipantInfo
    #> <0 rows> (or 0-length row.names)
    #> 
    #> $CTOPPElision_Raw
    #> [1] ParticipantID   Variable        DIRT            ParticipantInfo
    #> <0 rows> (or 0-length row.names)
    #> 
    #> $CTOPPElision_Scaled
    #> [1] ParticipantID   Variable        DIRT            ParticipantInfo
    #> <0 rows> (or 0-length row.names)
    #> 
    #> $EVT_Date
    #>   ParticipantID Variable       DIRT ParticipantInfo
    #> 1          004L EVT_Date 2013-11-13      2013-11-15
    #> 2          052L EVT_Date 2014-05-13      2014-05-16
    #> 3          605L EVT_Date 2013-12-02      2013-11-02
    #> 4          607L EVT_Date 2013-12-16      2013-12-06
    #> 5          624L EVT_Date 2014-02-07      2014-01-07
    #> 6          659L EVT_Date 2014-10-18      2014-09-20
    #> 
    #> $EVT_Form
    #> [1] ParticipantID   Variable        DIRT            ParticipantInfo
    #> <0 rows> (or 0-length row.names)
    #> 
    #> $EVT_GSV
    #>   ParticipantID Variable DIRT ParticipantInfo
    #> 1          030L  EVT_GSV  126             149
    #> 2          659L  EVT_GSV  148             143
    #> 
    #> $EVT_Raw
    #>   ParticipantID Variable DIRT ParticipantInfo
    #> 1          030L  EVT_Raw   78              79
    #> 2          659L  EVT_Raw   78              70
    #> 
    #> $EVT_Standard
    #>   ParticipantID     Variable DIRT ParticipantInfo
    #> 1          030L EVT_Standard  108             130
    #> 2          659L EVT_Standard  137             110
    #> 
    #> $FruitStroop_Score
    #>   ParticipantID          Variable DIRT ParticipantInfo
    #> 1          666L FruitStroop_Score  2.8            2.89
    #> 
    #> $KBIT_Raw
    #> [1] ParticipantID   Variable        DIRT            ParticipantInfo
    #> <0 rows> (or 0-length row.names)
    #> 
    #> $KBIT_Standard
    #> [1] ParticipantID   Variable        DIRT            ParticipantInfo
    #> <0 rows> (or 0-length row.names)
    #> 
    #> $PPVT_Date
    #>   ParticipantID  Variable       DIRT ParticipantInfo
    #> 1          002L PPVT_Date 2013-11-15      2013-11-08
    #> 2          005L PPVT_Date 2013-11-19      2013-11-14
    #> 3          025L PPVT_Date 2014-05-27      2014-05-21
    #> 4          042L PPVT_Date 2014-06-13      2014-06-12
    #> 5          043L PPVT_Date 2014-06-09      2014-06-08
    #> 6          089L PPVT_Date 2014-09-20      2014-10-04
    #> 7          108L PPVT_Date 2015-01-12      2015-02-12
    #> 8          119L PPVT_Date 2014-12-19      2014-12-16
    #> 
    #> $PPVT_Form
    #> [1] ParticipantID   Variable        DIRT            ParticipantInfo
    #> <0 rows> (or 0-length row.names)
    #> 
    #> $PPVT_GSV
    #>   ParticipantID Variable DIRT ParticipantInfo
    #> 1          126L PPVT_GSV  136             137
    #> 
    #> $PPVT_Raw
    #>   ParticipantID Variable DIRT ParticipantInfo
    #> 1          656L PPVT_Raw   91              90
    #> 
    #> $PPVT_Standard
    #>   ParticipantID      Variable DIRT ParticipantInfo
    #> 1          081L PPVT_Standard  144             146
    #> 2          089L PPVT_Standard   99              96
    #> 
    #> $VerbalFluency_AgeEquivalent
    #> [1] ParticipantID   Variable        DIRT            ParticipantInfo
    #> <0 rows> (or 0-length row.names)
    #> 
    #> $VerbalFluency_Score
    #> [1] ParticipantID   Variable        DIRT            ParticipantInfo
    #> <0 rows> (or 0-length row.names)
