TP3 Data Integrity Check
================
Tristan Mahr
2016-05-18

In Spring 2015, we had our data-entry team re-enter test scores gathered in the longitudinal study, so that we could find data-entry discrepancies. This script compares the original to the re-entered scores.

Participant pool comparison
---------------------------

Do the same participants contribute scores in each set?

Participants in original score-set ("ParticipantInfo") *not in* the re-entered score-set ("DIRT"):

    #> Source: local data frame [0 x 2]
    #> 
    #> Variables not shown: Source (chr), ParticipantID (chr)

Participants in re-entered score-set ("DIRT") *not in* the original score-set ("ParticipantInfo"):

    #> Source: local data frame [0 x 2]
    #> 
    #> Variables not shown: Source (chr), ParticipantID (chr)

Verbal Fluency Value Formatting Comparison
------------------------------------------

The most fiddly field seems to be the Verbal Fluency age-equivalents score.

These are the unique values found in the original score-set.

    #>  [1] "<2;0" "2;1"  "2;10" "2;3"  "2;5"  "2;8"  "3;0"  "3;1"  "3;11" "3;3" 
    #> [11] "3;4"  "3;6"  "3;7"  "3;9"  "4;0"  "4;10" "4;2"  "4;4"  "4;5"  "4;7" 
    #> [21] "4;9"  "5;0"  "5;10" "5;2"  "5;3"  "5;5"  "5;7"  "5;8"  "6;0"  "6;1" 
    #> [31] "6;10" "6;3"  "6;5"  "6;8"  "7;10" "7;2"  "7;4"  "8;0"  "9;8"

Some of those values used to have leading spaces. These are the rows with spaces located in the score. (Empty is good.)

    #> Source: local data frame [0 x 3]
    #> 
    #> Variables not shown: ParticipantID (chr), Source (chr),
    #>   VerbalFluency_AgeEquivalent (chr)

These are the unique values found in the re-entry score-set.

    #>  [1] "<2;0" "2;1"  "2;10" "2;3"  "2;5"  "2;8"  "3;0"  "3;1"  "3;11" "3;3" 
    #> [11] "3;4"  "3;6"  "3;7"  "3;9"  "4;0"  "4;10" "4;2"  "4;4"  "4;5"  "4;7" 
    #> [21] "4;9"  "5;0"  "5;10" "5;2"  "5;3"  "5;5"  "5;7"  "5;8"  "6;0"  "6;1" 
    #> [31] "6;10" "6;3"  "6;5"  "6;8"  "7;10" "7;2"  "7;4"  "8;0"  "9;8"

We used to write chronological ages as "Year-Month" but have since switched to "Year;Month", so we still check for these hyphens. (Empty is good.)

    #> Source: local data frame [0 x 5]
    #> 
    #> Variables not shown: Site (chr), Study (chr), ParticipantID (chr),
    #>   Variable (chr), Value (chr)

Value Comparison
----------------

We now compare the scores in each score-set. This check is only being performed on participants in both score-sets.

    #> $CTOPPBlending_Raw
    #>   ParticipantID          Variable DIRT ParticipantInfo
    #> 1          089L CTOPPBlending_Raw   MD            <NA>
    #> 
    #> $CTOPPBlending_Scaled
    #>   ParticipantID             Variable DIRT ParticipantInfo
    #> 1          089L CTOPPBlending_Scaled   MD            <NA>
    #> 2          671L CTOPPBlending_Scaled    1              10
    #> 
    #> $CTOPPElision_Raw
    #>   ParticipantID         Variable     DIRT ParticipantInfo
    #> 1          001L CTOPPElision_Raw 0.000000               0
    #> 2          089L CTOPPElision_Raw       MD            <NA>
    #> 
    #> $CTOPPElision_Scaled
    #>   ParticipantID            Variable     DIRT ParticipantInfo
    #> 1          001L CTOPPElision_Scaled 7.000000               7
    #> 2          043L CTOPPElision_Scaled       12              10
    #> 3          089L CTOPPElision_Scaled       MD            <NA>
    #> 
    #> $DELV_Date
    #>     ParticipantID  Variable       DIRT ParticipantInfo
    #> 1            001L DELV_Date 2015-08-03              NA
    #> 2            002L DELV_Date       <NA>              NA
    #> 3            003L DELV_Date       <NA>              NA
    #> 4            004L DELV_Date       <NA>              NA
    #> 5            005L DELV_Date       <NA>              NA
    #> 6            006L DELV_Date       <NA>              NA
    #> 7            007L DELV_Date       <NA>              NA
    #> 8            008L DELV_Date       <NA>              NA
    #> 9            009L DELV_Date       <NA>              NA
    #> 10           010L DELV_Date       <NA>              NA
    #> 11           011L DELV_Date       <NA>              NA
    #> 12           012L DELV_Date       <NA>              NA
    #> 13           013L DELV_Date       <NA>              NA
    #> 14           014L DELV_Date       <NA>              NA
    #> 15           015L DELV_Date       <NA>              NA
    #> 16           016L DELV_Date       <NA>              NA
    #> 17           017L DELV_Date       <NA>              NA
    #> 18           018L DELV_Date       <NA>              NA
    #> 19           019L DELV_Date       <NA>              NA
    #> 20           020L DELV_Date       <NA>              NA
    #> 21           021L DELV_Date       <NA>              NA
    #> 22           022L DELV_Date       <NA>              NA
    #> 23           023L DELV_Date 2015-06-01              NA
    #> 24           024L DELV_Date 2015-03-13              NA
    #> 25           025L DELV_Date 2015-07-06              NA
    #> 26           026L DELV_Date       <NA>              NA
    #> 27           027L DELV_Date 2015-03-06              NA
    #> 28           028L DELV_Date       <NA>              NA
    #> 29           029L DELV_Date       <NA>              NA
    #> 30           030L DELV_Date       <NA>              NA
    #> 31           031L DELV_Date       <NA>              NA
    #> 32           032L DELV_Date       <NA>              NA
    #> 33           033L DELV_Date       <NA>              NA
    #> 34           034L DELV_Date       <NA>              NA
    #> 35           035L DELV_Date 2015-06-20              NA
    #> 36           036L DELV_Date 2015-05-13              NA
    #> 37           037L DELV_Date       <NA>              NA
    #> 38           038L DELV_Date       <NA>              NA
    #> 39           039L DELV_Date       <NA>              NA
    #> 40           040L DELV_Date       <NA>              NA
    #> 41           041L DELV_Date       <NA>              NA
    #> 42           042L DELV_Date       <NA>              NA
    #> 43           043L DELV_Date       <NA>              NA
    #> 44           044L DELV_Date       <NA>              NA
    #> 45           045L DELV_Date       <NA>              NA
    #> 46           046L DELV_Date 2015-04-15              NA
    #> 47           047L DELV_Date       <NA>              NA
    #> 48           049L DELV_Date 2015-08-17              NA
    #> 49           050L DELV_Date       <NA>              NA
    #> 50           051L DELV_Date       <NA>              NA
    #> 51           052L DELV_Date       <NA>              NA
    #> 52           053L DELV_Date       <NA>              NA
    #> 53           054L DELV_Date       <NA>              NA
    #> 54           055L DELV_Date       <NA>              NA
    #> 55           056L DELV_Date       <NA>              NA
    #> 56           057L DELV_Date       <NA>              NA
    #> 57           058L DELV_Date       <NA>              NA
    #> 58           059L DELV_Date       <NA>              NA
    #> 59           060L DELV_Date       <NA>              NA
    #> 60           061L DELV_Date       <NA>              NA
    #> 61           062L DELV_Date       <NA>              NA
    #> 62           063L DELV_Date       <NA>              NA
    #> 63           064L DELV_Date       <NA>              NA
    #> 64           065L DELV_Date 2015-07-09              NA
    #> 65           066L DELV_Date 2015-06-25              NA
    #> 66           067L DELV_Date       <NA>              NA
    #> 67           068L DELV_Date       <NA>              NA
    #> 68           069L DELV_Date       <NA>              NA
    #> 69           071L DELV_Date       <NA>              NA
    #> 70           072L DELV_Date       <NA>              NA
    #> 71           073L DELV_Date       <NA>              NA
    #> 72           074L DELV_Date       <NA>              NA
    #> 73           075L DELV_Date       <NA>              NA
    #> 74           076L DELV_Date       <NA>              NA
    #> 75           077L DELV_Date       <NA>              NA
    #> 76           078L DELV_Date       <NA>              NA
    #> 77           079L DELV_Date       <NA>              NA
    #> 78           080L DELV_Date       <NA>              NA
    #> 79           081L DELV_Date       <NA>              NA
    #> 80           082L DELV_Date       <NA>              NA
    #> 81           083L DELV_Date       <NA>              NA
    #> 82           084L DELV_Date       <NA>              NA
    #> 83           085L DELV_Date       <NA>              NA
    #> 84           086L DELV_Date       <NA>              NA
    #> 85           087L DELV_Date       <NA>              NA
    #> 86           088L DELV_Date       <NA>              NA
    #> 87           089L DELV_Date 2015-10-03              NA
    #> 88           090L DELV_Date       <NA>              NA
    #> 89           091L DELV_Date       <NA>              NA
    #> 90           092L DELV_Date       <NA>              NA
    #> 91           093L DELV_Date 2015-11-23              NA
    #> 92           094L DELV_Date 2015-11-23              NA
    #> 93           095L DELV_Date       <NA>              NA
    #> 94           096L DELV_Date       <NA>              NA
    #> 95           097L DELV_Date       <NA>              NA
    #> 96           098L DELV_Date       <NA>              NA
    #> 97           099L DELV_Date       <NA>              NA
    #> 98           100L DELV_Date       <NA>              NA
    #> 99           101L DELV_Date       <NA>              NA
    #> 100          102L DELV_Date       <NA>              NA
    #> 101          103L DELV_Date       <NA>              NA
    #> 102          104L DELV_Date       <NA>              NA
    #> 103          105L DELV_Date       <NA>              NA
    #> 104          106L DELV_Date       <NA>              NA
    #> 105          107L DELV_Date       <NA>              NA
    #> 106          108L DELV_Date 2016-02-08              NA
    #> 107          109L DELV_Date       <NA>              NA
    #> 108          110L DELV_Date       <NA>              NA
    #> 109          111L DELV_Date       <NA>              NA
    #> 110          112L DELV_Date       <NA>              NA
    #> 111          113L DELV_Date       <NA>              NA
    #> 112          114L DELV_Date       <NA>              NA
    #> 113          115L DELV_Date       <NA>              NA
    #> 114          116L DELV_Date       <NA>              NA
    #> 115          117L DELV_Date       <NA>              NA
    #> 116          118L DELV_Date       <NA>              NA
    #> 117          119L DELV_Date       <NA>              NA
    #> 118          120L DELV_Date       <NA>              NA
    #> 119          121L DELV_Date       <NA>              NA
    #> 120          122L DELV_Date       <NA>              NA
    #> 121          123L DELV_Date       <NA>              NA
    #> 122          124L DELV_Date       <NA>              NA
    #> 123          125L DELV_Date       <NA>              NA
    #> 124          126L DELV_Date       <NA>              NA
    #> 125          127L DELV_Date       <NA>              NA
    #> 126          128L DELV_Date 2016-01-29              NA
    #> 127          129L DELV_Date       <NA>              NA
    #> 128          130L DELV_Date       <NA>              NA
    #> 129          131L DELV_Date       <NA>              NA
    #> 130          132L DELV_Date       <NA>              NA
    #> 131          133L DELV_Date       <NA>              NA
    #> 132          134L DELV_Date       <NA>              NA
    #> 133          600L DELV_Date       <NA>              NA
    #> 134          601L DELV_Date       <NA>              NA
    #> 135          602L DELV_Date       <NA>              NA
    #> 136          603L DELV_Date       <NA>              NA
    #> 137          604L DELV_Date       <NA>              NA
    #> 138          605L DELV_Date 2014-11-18              NA
    #> 139          606L DELV_Date       <NA>              NA
    #> 140          607L DELV_Date       <NA>              NA
    #> 141          608L DELV_Date 2015-01-09              NA
    #> 142          609L DELV_Date 2014-12-19              NA
    #> 143          610L DELV_Date       <NA>              NA
    #> 144          611L DELV_Date       <NA>              NA
    #> 145          612L DELV_Date       <NA>              NA
    #> 146          613L DELV_Date       <NA>              NA
    #> 147          614L DELV_Date       <NA>              NA
    #> 148          615L DELV_Date       <NA>              NA
    #> 149          616L DELV_Date       <NA>              NA
    #> 150          617L DELV_Date       <NA>              NA
    #> 151          618L DELV_Date       <NA>              NA
    #> 152          619L DELV_Date       <NA>              NA
    #> 153          620L DELV_Date       <NA>              NA
    #> 154          621L DELV_Date       <NA>              NA
    #> 155          622L DELV_Date       <NA>              NA
    #> 156          623L DELV_Date       <NA>              NA
    #> 157          624L DELV_Date       <NA>              NA
    #> 158          625L DELV_Date       <NA>              NA
    #> 159          626L DELV_Date       <NA>              NA
    #> 160          627L DELV_Date       <NA>              NA
    #> 161          628L DELV_Date       <NA>              NA
    #> 162          629L DELV_Date       <NA>              NA
    #> 163          630L DELV_Date       <NA>              NA
    #> 164          631L DELV_Date 2015-06-20              NA
    #> 165          632L DELV_Date       <NA>              NA
    #> 166          633L DELV_Date       <NA>              NA
    #> 167          634L DELV_Date       <NA>              NA
    #> 168          635L DELV_Date       <NA>              NA
    #> 169          636L DELV_Date       <NA>              NA
    #> 170          637L DELV_Date       <NA>              NA
    #> 171          638L DELV_Date 2015-06-12              NA
    #> 172          639L DELV_Date       <NA>              NA
    #> 173          640L DELV_Date       <NA>              NA
    #> 174          641L DELV_Date       <NA>              NA
    #> 175          642L DELV_Date       <NA>              NA
    #> 176          643L DELV_Date       <NA>              NA
    #> 177          644L DELV_Date       <NA>              NA
    #> 178          645L DELV_Date       <NA>              NA
    #> 179          646L DELV_Date       <NA>              NA
    #> 180          647L DELV_Date       <NA>              NA
    #> 181          648L DELV_Date       <NA>              NA
    #> 182          649L DELV_Date       <NA>              NA
    #> 183          650L DELV_Date       <NA>              NA
    #> 184          651L DELV_Date       <NA>              NA
    #> 185          652L DELV_Date       <NA>              NA
    #> 186          653L DELV_Date       <NA>              NA
    #> 187          654L DELV_Date       <NA>              NA
    #> 188          655L DELV_Date       <NA>              NA
    #> 189          656L DELV_Date       <NA>              NA
    #> 190          657L DELV_Date       <NA>              NA
    #> 191          658L DELV_Date       <NA>              NA
    #> 192          659L DELV_Date       <NA>              NA
    #> 193          660L DELV_Date 2015-11-14              NA
    #> 194          661L DELV_Date       <NA>              NA
    #> 195          662L DELV_Date       <NA>              NA
    #> 196          663L DELV_Date       <NA>              NA
    #> 197          664L DELV_Date       <NA>              NA
    #> 198          665L DELV_Date 2016-01-07              NA
    #> 199          666L DELV_Date 2015-10-09              NA
    #> 200          667L DELV_Date       <NA>              NA
    #> 201          668L DELV_Date       <NA>              NA
    #> 202          669L DELV_Date       <NA>              NA
    #> 203          670L DELV_Date       <NA>              NA
    #> 204          671L DELV_Date 2015-12-19              NA
    #> 205          672L DELV_Date       <NA>              NA
    #> 206          673L DELV_Date       <NA>              NA
    #> 207          674L DELV_Date       <NA>              NA
    #> 208          675L DELV_Date       <NA>              NA
    #> 209          676L DELV_Date       <NA>              NA
    #> 210          677L DELV_Date 2016-01-08              NA
    #> 211          678L DELV_Date       <NA>              NA
    #> 212          679L DELV_Date 2016-03-05              NA
    #> 213          680L DELV_Date 2016-01-07              NA
    #> 214          681L DELV_Date 2016-02-23              NA
    #> 215          682L DELV_Date       <NA>              NA
    #> 216          683L DELV_Date       <NA>              NA
    #> 217          684L DELV_Date 2016-02-27              NA
    #> 218          685L DELV_Date 2016-03-12              NA
    #> 219          686L DELV_Date 2016-03-12              NA
    #> 220          687L DELV_Date       <NA>              NA
    #> 221          688L DELV_Date       <NA>              NA
    #> 222          689L DELV_Date       <NA>              NA
    #> 
    #> $DELV_LanguageRisk
    #>   ParticipantID          Variable DIRT ParticipantInfo
    #> 1          605L DELV_LanguageRisk    4            <NA>
    #> 2          608L DELV_LanguageRisk    1            <NA>
    #> 3          609L DELV_LanguageRisk    4            <NA>
    #> 
    #> $DELV_LanguageRisk_DiagnosticErrorScore
    #>   ParticipantID                               Variable DIRT
    #> 1          605L DELV_LanguageRisk_DiagnosticErrorScore   18
    #> 2          608L DELV_LanguageRisk_DiagnosticErrorScore    1
    #> 3          609L DELV_LanguageRisk_DiagnosticErrorScore   13
    #> 4          631L DELV_LanguageRisk_DiagnosticErrorScore <NA>
    #> 5          638L DELV_LanguageRisk_DiagnosticErrorScore <NA>
    #>   ParticipantInfo
    #> 1               3
    #> 2               0
    #> 3               3
    #> 4               0
    #> 5               0
    #> 
    #> $DELV_LanguageVar1
    #> [1] ParticipantID   Variable        DIRT            ParticipantInfo
    #> <0 rows> (or 0-length row.names)
    #> 
    #> $DELV_LanguageVar2
    #> [1] ParticipantID   Variable        DIRT            ParticipantInfo
    #> <0 rows> (or 0-length row.names)
    #> 
    #> $DELV_LanguageVar3
    #>   ParticipantID          Variable DIRT ParticipantInfo
    #> 1          638L DELV_LanguageVar3 <NA>               0
    #> 
    #> $EVT_Date
    #>   ParticipantID Variable       DIRT ParticipantInfo
    #> 1          021L EVT_Date 2015-03-14      2014-03-14
    #> 2          609L EVT_Date 2014-11-14      2014-10-11
    #> 3          614L EVT_Date 2014-12-29      2014-10-29
    #> 4          622L EVT_Date 2015-02-28      2015-02-21
    #> 5          623L EVT_Date 2015-02-13      2015-02-23
    #> 6          683L EVT_Date 2016-02-01      2016-02-02
    #> 7          685L EVT_Date 2016-02-13      2016-02-11
    #> 8          686L EVT_Date 2016-02-13      2016-02-11
    #> 
    #> $EVT_Form
    #>    ParticipantID Variable DIRT ParticipantInfo
    #> 1           600L EVT_Form    A            <NA>
    #> 2           602L EVT_Form    A            <NA>
    #> 3           604L EVT_Form    A            <NA>
    #> 4           605L EVT_Form    A            <NA>
    #> 5           607L EVT_Form    A            <NA>
    #> 6           608L EVT_Form    A            <NA>
    #> 7           609L EVT_Form    A            <NA>
    #> 8           610L EVT_Form    A            <NA>
    #> 9           611L EVT_Form    A            <NA>
    #> 10          612L EVT_Form    A            <NA>
    #> 11          614L EVT_Form    A            <NA>
    #> 12          615L EVT_Form    A            <NA>
    #> 13          616L EVT_Form    A            <NA>
    #> 14          619L EVT_Form    A            <NA>
    #> 15          620L EVT_Form    A            <NA>
    #> 16          622L EVT_Form    A            <NA>
    #> 17          623L EVT_Form    A            <NA>
    #> 18          624L EVT_Form    A            <NA>
    #> 19          625L EVT_Form    A            <NA>
    #> 20          627L EVT_Form    A            <NA>
    #> 21          628L EVT_Form    A            <NA>
    #> 22          629L EVT_Form    A            <NA>
    #> 23          630L EVT_Form    A            <NA>
    #> 24          631L EVT_Form    A            <NA>
    #> 25          632L EVT_Form    A            <NA>
    #> 26          636L EVT_Form    A            <NA>
    #> 27          638L EVT_Form    A            <NA>
    #> 28          639L EVT_Form    A            <NA>
    #> 29          640L EVT_Form    A            <NA>
    #> 30          644L EVT_Form    A            <NA>
    #> 31          651L EVT_Form    A            <NA>
    #> 32          652L EVT_Form    A            <NA>
    #> 33          655L EVT_Form    A            <NA>
    #> 34          656L EVT_Form    A            <NA>
    #> 35          657L EVT_Form    A            <NA>
    #> 36          658L EVT_Form    A            <NA>
    #> 37          659L EVT_Form    A            <NA>
    #> 38          660L EVT_Form    A            <NA>
    #> 39          661L EVT_Form    A            <NA>
    #> 40          664L EVT_Form    A            <NA>
    #> 41          665L EVT_Form    A            <NA>
    #> 42          666L EVT_Form    A            <NA>
    #> 43          667L EVT_Form    A            <NA>
    #> 44          668L EVT_Form    A            <NA>
    #> 45          669L EVT_Form    A            <NA>
    #> 46          670L EVT_Form    A            <NA>
    #> 47          671L EVT_Form    A            <NA>
    #> 48          673L EVT_Form    A            <NA>
    #> 49          674L EVT_Form    A            <NA>
    #> 50          677L EVT_Form    A            <NA>
    #> 51          678L EVT_Form    A            <NA>
    #> 52          679L EVT_Form    A            <NA>
    #> 53          680L EVT_Form    A            <NA>
    #> 54          681L EVT_Form    A            <NA>
    #> 55          683L EVT_Form    A            <NA>
    #> 56          684L EVT_Form    A            <NA>
    #> 57          685L EVT_Form    A            <NA>
    #> 58          686L EVT_Form    A            <NA>
    #> 59          689L EVT_Form    A            <NA>
    #> 
    #> $EVT_GSV
    #>   ParticipantID Variable       DIRT ParticipantInfo
    #> 1          001L  EVT_GSV 133.000000             133
    #> 2          623L  EVT_GSV        145             125
    #> 
    #> $EVT_Raw
    #>   ParticipantID Variable      DIRT ParticipantInfo
    #> 1          001L  EVT_Raw 57.000000              57
    #> 2          607L  EVT_Raw        80              82
    #> 3          623L  EVT_Raw        73              48
    #> 
    #> $EVT_Standard
    #>   ParticipantID     Variable       DIRT ParticipantInfo
    #> 1          001L EVT_Standard 103.000000             103
    #> 2          074L EVT_Standard        113             133
    #> 3          623L EVT_Standard        116             104
    #> 
    #> $GFTA_Date
    #>     ParticipantID  Variable       DIRT ParticipantInfo
    #> 1            001L GFTA_Date 2015-08-04              NA
    #> 2            002L GFTA_Date 2014-11-15              NA
    #> 3            003L GFTA_Date 2014-10-08              NA
    #> 4            004L GFTA_Date 2014-12-04              NA
    #> 5            005L GFTA_Date 2014-11-14              NA
    #> 6            006L GFTA_Date 2015-02-10              NA
    #> 7            007L GFTA_Date 2014-11-21              NA
    #> 8            008L GFTA_Date 2014-11-21              NA
    #> 9            009L GFTA_Date       <NA>              NA
    #> 10           010L GFTA_Date 2014-12-15              NA
    #> 11           011L GFTA_Date 2015-02-09              NA
    #> 12           012L GFTA_Date 2015-01-29              NA
    #> 13           013L GFTA_Date       <NA>              NA
    #> 14           014L GFTA_Date 2015-02-18              NA
    #> 15           015L GFTA_Date 2014-12-15              NA
    #> 16           016L GFTA_Date 2015-03-09              NA
    #> 17           017L GFTA_Date       <NA>              NA
    #> 18           018L GFTA_Date 2015-02-28              NA
    #> 19           019L GFTA_Date 2015-02-22              NA
    #> 20           020L GFTA_Date 2015-02-22              NA
    #> 21           021L GFTA_Date 2015-04-05              NA
    #> 22           022L GFTA_Date       <NA>              NA
    #> 23           023L GFTA_Date       <NA>              NA
    #> 24           024L GFTA_Date 2015-04-08              NA
    #> 25           025L GFTA_Date 2015-07-08              NA
    #> 26           026L GFTA_Date 2015-03-27              NA
    #> 27           027L GFTA_Date 2015-03-04              NA
    #> 28           028L GFTA_Date       <NA>              NA
    #> 29           029L GFTA_Date 2015-05-20              NA
    #> 30           030L GFTA_Date 2015-03-31              NA
    #> 31           031L GFTA_Date 2015-07-21              NA
    #> 32           032L GFTA_Date 2015-04-24              NA
    #> 33           033L GFTA_Date 2015-05-28              NA
    #> 34           034L GFTA_Date 2015-04-13              NA
    #> 35           035L GFTA_Date 2015-07-11              NA
    #> 36           036L GFTA_Date       <NA>              NA
    #> 37           037L GFTA_Date 2015-05-27              NA
    #> 38           038L GFTA_Date 2015-09-12              NA
    #> 39           039L GFTA_Date 2015-07-02              NA
    #> 40           040L GFTA_Date 2015-05-09              NA
    #> 41           041L GFTA_Date 2015-06-09              NA
    #> 42           042L GFTA_Date 2015-06-09              NA
    #> 43           043L GFTA_Date 2015-06-22              NA
    #> 44           044L GFTA_Date 2016-01-25              NA
    #> 45           045L GFTA_Date       <NA>              NA
    #> 46           046L GFTA_Date 2015-04-15              NA
    #> 47           047L GFTA_Date       <NA>              NA
    #> 48           049L GFTA_Date 2015-08-17              NA
    #> 49           050L GFTA_Date 2015-11-18              NA
    #> 50           051L GFTA_Date 2016-01-07              NA
    #> 51           052L GFTA_Date 2015-05-13              NA
    #> 52           053L GFTA_Date 2016-01-15              NA
    #> 53           054L GFTA_Date       <NA>              NA
    #> 54           055L GFTA_Date 2015-11-19              NA
    #> 55           056L GFTA_Date 2015-09-19              NA
    #> 56           057L GFTA_Date 2015-07-03              NA
    #> 57           058L GFTA_Date 2015-07-25              NA
    #> 58           059L GFTA_Date       <NA>              NA
    #> 59           060L GFTA_Date       <NA>              NA
    #> 60           061L GFTA_Date 2015-07-14              NA
    #> 61           062L GFTA_Date       <NA>              NA
    #> 62           063L GFTA_Date 2015-07-28              NA
    #> 63           064L GFTA_Date 2015-08-12              NA
    #> 64           065L GFTA_Date 2015-07-15              NA
    #> 65           066L GFTA_Date 2015-06-30              NA
    #> 66           067L GFTA_Date       <NA>              NA
    #> 67           068L GFTA_Date 2015-06-25              NA
    #> 68           069L GFTA_Date 2015-07-22              NA
    #> 69           071L GFTA_Date 2015-08-03              NA
    #> 70           072L GFTA_Date 2015-08-24              NA
    #> 71           073L GFTA_Date       <NA>              NA
    #> 72           074L GFTA_Date 2015-08-17              NA
    #> 73           075L GFTA_Date 2015-09-04              NA
    #> 74           076L GFTA_Date 2016-01-11              NA
    #> 75           077L GFTA_Date 2015-09-28              NA
    #> 76           078L GFTA_Date 2016-01-22              NA
    #> 77           079L GFTA_Date       <NA>              NA
    #> 78           080L GFTA_Date 2015-09-28              NA
    #> 79           081L GFTA_Date 2015-09-29              NA
    #> 80           082L GFTA_Date 2015-11-23              NA
    #> 81           083L GFTA_Date 2016-01-13              NA
    #> 82           084L GFTA_Date       <NA>              NA
    #> 83           085L GFTA_Date 2015-11-04              NA
    #> 84           086L GFTA_Date       <NA>              NA
    #> 85           087L GFTA_Date 2015-10-27              NA
    #> 86           088L GFTA_Date 2015-10-02              NA
    #> 87           089L GFTA_Date         MD              NA
    #> 88           090L GFTA_Date 2015-11-19              NA
    #> 89           091L GFTA_Date       <NA>              NA
    #> 90           092L GFTA_Date 2015-10-22              NA
    #> 91           093L GFTA_Date 2015-11-23              NA
    #> 92           094L GFTA_Date 2015-11-23              NA
    #> 93           095L GFTA_Date 2015-11-09              NA
    #> 94           096L GFTA_Date 2015-11-09              NA
    #> 95           097L GFTA_Date 2015-12-05              NA
    #> 96           098L GFTA_Date 2015-12-05              NA
    #> 97           099L GFTA_Date 2015-11-14              NA
    #> 98           100L GFTA_Date 2015-11-17              NA
    #> 99           101L GFTA_Date 2015-11-17              NA
    #> 100          102L GFTA_Date       <NA>              NA
    #> 101          103L GFTA_Date       <NA>              NA
    #> 102          104L GFTA_Date 2015-11-20              NA
    #> 103          105L GFTA_Date       <NA>              NA
    #> 104          106L GFTA_Date 2015-11-20              NA
    #> 105          107L GFTA_Date 2016-01-09              NA
    #> 106          108L GFTA_Date 2016-02-15              NA
    #> 107          109L GFTA_Date 2015-12-17              NA
    #> 108          110L GFTA_Date 2016-01-19              NA
    #> 109          111L GFTA_Date 2016-01-12              NA
    #> 110          112L GFTA_Date 2015-12-17              NA
    #> 111          113L GFTA_Date 2015-12-22              NA
    #> 112          114L GFTA_Date 2015-12-19              NA
    #> 113          115L GFTA_Date       <NA>              NA
    #> 114          116L GFTA_Date       <NA>              NA
    #> 115          117L GFTA_Date 2015-12-22              NA
    #> 116          118L GFTA_Date 2015-12-21              NA
    #> 117          119L GFTA_Date 2015-12-21              NA
    #> 118          120L GFTA_Date       <NA>              NA
    #> 119          121L GFTA_Date 2015-12-30              NA
    #> 120          122L GFTA_Date 2015-12-30              NA
    #> 121          123L GFTA_Date       <NA>              NA
    #> 122          124L GFTA_Date 2016-01-13              NA
    #> 123          125L GFTA_Date       <NA>              NA
    #> 124          126L GFTA_Date 2016-02-09              NA
    #> 125          127L GFTA_Date 2016-01-15              NA
    #> 126          128L GFTA_Date 2016-01-29              NA
    #> 127          129L GFTA_Date 2016-03-06              NA
    #> 128          130L GFTA_Date 2016-03-06              NA
    #> 129          131L GFTA_Date 2016-02-13              NA
    #> 130          132L GFTA_Date       <NA>              NA
    #> 131          133L GFTA_Date 2016-02-03              NA
    #> 132          134L GFTA_Date       <NA>              NA
    #> 133          600L GFTA_Date 2014-12-12              NA
    #> 134          601L GFTA_Date       <NA>              NA
    #> 135          602L GFTA_Date 2014-12-18              NA
    #> 136          603L GFTA_Date       <NA>              NA
    #> 137          604L GFTA_Date 2014-12-23              NA
    #> 138          605L GFTA_Date 2014-11-15              NA
    #> 139          606L GFTA_Date       <NA>              NA
    #> 140          607L GFTA_Date 2014-12-16              NA
    #> 141          608L GFTA_Date 2014-12-30              NA
    #> 142          609L GFTA_Date 2014-12-12              NA
    #> 143          610L GFTA_Date 2014-11-21              NA
    #> 144          611L GFTA_Date 2015-03-27              NA
    #> 145          612L GFTA_Date 2015-01-26              NA
    #> 146          613L GFTA_Date       <NA>              NA
    #> 147          614L GFTA_Date 2015-01-05              NA
    #> 148          615L GFTA_Date 2015-05-21              NA
    #> 149          616L GFTA_Date 2015-02-07              NA
    #> 150          617L GFTA_Date       <NA>              NA
    #> 151          618L GFTA_Date       <NA>              NA
    #> 152          619L GFTA_Date 2015-02-28              NA
    #> 153          620L GFTA_Date 2015-01-23              NA
    #> 154          621L GFTA_Date       <NA>              NA
    #> 155          622L GFTA_Date 2015-03-12              NA
    #> 156          623L GFTA_Date 2015-02-27              NA
    #> 157          624L GFTA_Date 2015-03-06              NA
    #> 158          625L GFTA_Date 2015-03-24              NA
    #> 159          626L GFTA_Date       <NA>              NA
    #> 160          627L GFTA_Date 2015-02-07              NA
    #> 161          628L GFTA_Date 2015-04-30              NA
    #> 162          629L GFTA_Date 2015-05-08              NA
    #> 163          630L GFTA_Date 2016-01-19              NA
    #> 164          631L GFTA_Date 2015-06-13              NA
    #> 165          632L GFTA_Date 2015-05-02              NA
    #> 166          633L GFTA_Date       <NA>              NA
    #> 167          634L GFTA_Date       <NA>              NA
    #> 168          635L GFTA_Date       <NA>              NA
    #> 169          636L GFTA_Date 2015-05-11              NA
    #> 170          637L GFTA_Date       <NA>              NA
    #> 171          638L GFTA_Date 2015-06-10              NA
    #> 172          639L GFTA_Date 2015-06-09              NA
    #> 173          640L GFTA_Date 2015-06-13              NA
    #> 174          641L GFTA_Date       <NA>              NA
    #> 175          642L GFTA_Date       <NA>              NA
    #> 176          643L GFTA_Date       <NA>              NA
    #> 177          644L GFTA_Date 2015-08-21              NA
    #> 178          645L GFTA_Date       <NA>              NA
    #> 179          646L GFTA_Date       <NA>              NA
    #> 180          647L GFTA_Date       <NA>              NA
    #> 181          648L GFTA_Date       <NA>              NA
    #> 182          649L GFTA_Date       <NA>              NA
    #> 183          650L GFTA_Date       <NA>              NA
    #> 184          651L GFTA_Date 2015-11-07              NA
    #> 185          652L GFTA_Date 2015-07-30              NA
    #> 186          653L GFTA_Date       <NA>              NA
    #> 187          654L GFTA_Date       <NA>              NA
    #> 188          655L GFTA_Date 2015-12-18              NA
    #> 189          656L GFTA_Date 2015-07-27              NA
    #> 190          657L GFTA_Date 2015-09-25              NA
    #> 191          658L GFTA_Date 2015-09-01              NA
    #> 192          659L GFTA_Date 2015-09-11              NA
    #> 193          660L GFTA_Date 2015-11-14              NA
    #> 194          661L GFTA_Date 2015-11-06              NA
    #> 195          662L GFTA_Date       <NA>              NA
    #> 196          663L GFTA_Date       <NA>              NA
    #> 197          664L GFTA_Date 2015-11-11              NA
    #> 198          665L GFTA_Date 2015-11-21              NA
    #> 199          666L GFTA_Date 2015-10-08              NA
    #> 200          667L GFTA_Date 2015-10-24              NA
    #> 201          668L GFTA_Date 2015-10-10              NA
    #> 202          669L GFTA_Date 2015-10-09              NA
    #> 203          670L GFTA_Date 2015-09-25              NA
    #> 204          671L GFTA_Date 2015-12-12              NA
    #> 205          672L GFTA_Date       <NA>              NA
    #> 206          673L GFTA_Date 2015-12-19              NA
    #> 207          674L GFTA_Date 2015-12-04              NA
    #> 208          675L GFTA_Date       <NA>              NA
    #> 209          676L GFTA_Date       <NA>              NA
    #> 210          677L GFTA_Date 2016-01-05              NA
    #> 211          678L GFTA_Date 2016-02-19              NA
    #> 212          679L GFTA_Date 2016-03-09              NA
    #> 213          680L GFTA_Date 2015-12-17              NA
    #> 214          681L GFTA_Date 2016-02-09              NA
    #> 215          682L GFTA_Date       <NA>              NA
    #> 216          683L GFTA_Date 2016-02-26              NA
    #> 217          684L GFTA_Date 2016-01-30              NA
    #> 218          685L GFTA_Date 2016-02-20              NA
    #> 219          686L GFTA_Date 2016-02-20              NA
    #> 220          687L GFTA_Date       <NA>              NA
    #> 221          688L GFTA_Date       <NA>              NA
    #> 222          689L GFTA_Date 2016-03-01              NA
    #> 
    #> $KBIT_Raw
    #>   ParticipantID Variable DIRT ParticipantInfo
    #> 1          089L KBIT_Raw   MD            <NA>
    #> 
    #> $KBIT_Standard
    #>   ParticipantID      Variable DIRT ParticipantInfo
    #> 1          089L KBIT_Standard   MD            <NA>
    #> 
    #> $PPVT_Date
    #>   ParticipantID  Variable       DIRT ParticipantInfo
    #> 1          026L PPVT_Date 2015-03-27            <NA>
    #> 2          660L PPVT_Date          A      2015-11-14
    #> 
    #> $PPVT_Form
    #>    ParticipantID  Variable       DIRT ParticipantInfo
    #> 1           001L PPVT_Form          A            <NA>
    #> 2           025L PPVT_Form          A            <NA>
    #> 3           026L PPVT_Form          A            <NA>
    #> 4           027L PPVT_Form          A            <NA>
    #> 5           035L PPVT_Form          A            <NA>
    #> 6           049L PPVT_Form          A            <NA>
    #> 7           065L PPVT_Form          A            <NA>
    #> 8           066L PPVT_Form          A            <NA>
    #> 9           089L PPVT_Form          A            <NA>
    #> 10          093L PPVT_Form          A            <NA>
    #> 11          094L PPVT_Form          A            <NA>
    #> 12          108L PPVT_Form          A            <NA>
    #> 13          128L PPVT_Form          A            <NA>
    #> 14          605L PPVT_Form          A            <NA>
    #> 15          608L PPVT_Form          A            <NA>
    #> 16          609L PPVT_Form          A            <NA>
    #> 17          631L PPVT_Form          A            <NA>
    #> 18          638L PPVT_Form          A            <NA>
    #> 19          660L PPVT_Form 2015-11-14            <NA>
    #> 20          665L PPVT_Form          A            <NA>
    #> 21          666L PPVT_Form          A            <NA>
    #> 22          671L PPVT_Form          A            <NA>
    #> 23          677L PPVT_Form          A            <NA>
    #> 24          679L PPVT_Form          A            <NA>
    #> 25          680L PPVT_Form          A            <NA>
    #> 26          681L PPVT_Form          A            <NA>
    #> 27          684L PPVT_Form          A            <NA>
    #> 28          685L PPVT_Form          A            <NA>
    #> 29          686L PPVT_Form          A            <NA>
    #> 
    #> $PPVT_GSV
    #>   ParticipantID Variable DIRT ParticipantInfo
    #> 1          026L PPVT_GSV  112            <NA>
    #> 
    #> $PPVT_Raw
    #>   ParticipantID Variable DIRT ParticipantInfo
    #> 1          026L PPVT_Raw   59            <NA>
    #> 
    #> $PPVT_Standard
    #>   ParticipantID      Variable DIRT ParticipantInfo
    #> 1          026L PPVT_Standard   91            <NA>
    #> 
    #> $VerbalFluency_AgeEquivalent
    #>   ParticipantID                    Variable DIRT ParticipantInfo
    #> 1          624L VerbalFluency_AgeEquivalent  2;5             2;3
    #> 
    #> $VerbalFluency_Score
    #> [1] ParticipantID   Variable        DIRT            ParticipantInfo
    #> <0 rows> (or 0-length row.names)
