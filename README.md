textshape
============


[![Project Status: Wip - Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](http://www.repostatus.org/badges/0.1.0/wip.svg)](http://www.repostatus.org/#wip)
[![Build
Status](https://travis-ci.org/trinker/textshape.svg?branch=master)](https://travis-ci.org/trinker/textshape)
[![Coverage
Status](https://coveralls.io/repos/trinker/textshape/badge.svg?branch=master)](https://coveralls.io/r/trinker/textshape?branch=master)
<a href="https://img.shields.io/badge/Version-0.0.1-orange.svg"><img src="https://img.shields.io/badge/Version-0.0.1-orange.svg" alt="Version"/></a>
</p>
<img src="inst/textshape_logo/r_textshape.png" width="200" alt="textshape Logo">

**textshape** is small suite of text reshaping functions. Many of these
functions are descended from tools in the
[**qdapTools**](https://github.com/trinker/qdapTools) package. This
brings reshaping tools under one roof with specific functionality of the
package limited to text reshaping.


Table of Contents
============

-   [Functions](#functions)
-   [Installation](#installation)
-   [Contact](#contact)
-   [Examples](#examples)
    -   [Combining](#combining)
        -   [A Vector](#a-vector)
        -   [A Dataframe](#a-dataframe)
    -   [Tabulating](#tabulating)
        -   [A Vector](#a-vector)
        -   [A Dataframe](#a-dataframe)
    -   [Spanning](#spanning)
        -   [A Vector](#a-vector)
        -   [A Dataframe](#a-dataframe)
        -   [Gantt Plot](#gantt-plot)
    -   [Splitting](#splitting)
        -   [Indices](#indices)
        -   [Matches](#matches)
        -   [Portions](#portions)
        -   [Runs](#runs)
        -   [Sentences](#sentences)
        -   [Speakers](#speakers)
        -   [Tokens](#tokens)
        -   [Words](#words)

Functions
============


Most of the functions split/expand a `vector`, `list` or `data.frame`.
The `combine`, `duration`, & `mtabulate` functions are notable
exceptions. The table below describes the functions and their use:

<table>
<thead>
<tr class="header">
<th align="left">Function</th>
<th align="left">Used On</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><code>combine</code></td>
<td align="left"><code>vector</code>, <code>list</code>, <code>data.frame</code></td>
<td align="left">Combine and collapse elements</td>
</tr>
<tr class="even">
<td align="left"><code>duration</code></td>
<td align="left"><code>vector</code>, <code>data.frame</code></td>
<td align="left">Get duration (start-end times) for turns of talk in n words</td>
</tr>
<tr class="odd">
<td align="left"><code>mtabulate</code></td>
<td align="left"><code>vector</code>, <code>list</code>, <code>data.frame</code></td>
<td align="left">Dataframe/list version of <code>tabulate</code> to produce count matrix</td>
</tr>
<tr class="even">
<td align="left"><code>split_index</code></td>
<td align="left"><code>vector</code>, <code>list</code>, <code>data.frame</code></td>
<td align="left">Split at specified indices</td>
</tr>
<tr class="odd">
<td align="left"><code>split_match</code></td>
<td align="left"><code>vector</code></td>
<td align="left">Split vector at specified character/regex match</td>
</tr>
<tr class="even">
<td align="left"><code>split_portion</code></td>
<td align="left"><code>vector</code>*</td>
<td align="left">Split data into portioned chunks</td>
</tr>
<tr class="odd">
<td align="left"><code>split_run</code></td>
<td align="left"><code>vector</code>, <code>data.frame</code></td>
<td align="left">Split runs (e.g., &quot;aaabbbbcdddd&quot;)</td>
</tr>
<tr class="even">
<td align="left"><code>split_sentence</code></td>
<td align="left"><code>vector</code>, <code>data.frame</code></td>
<td align="left">Split sentences</td>
</tr>
<tr class="odd">
<td align="left"><code>split_speaker</code></td>
<td align="left"><code>data.frame</code></td>
<td align="left">Split combined speakers (e.g., &quot;Josh, Jake, Jim&quot;)</td>
</tr>
<tr class="even">
<td align="left"><code>split_token</code></td>
<td align="left"><code>vector</code>, <code>data.frame</code></td>
<td align="left">Split words and punctuation</td>
</tr>
<tr class="odd">
<td align="left"><code>split_word</code></td>
<td align="left"><code>vector</code>, <code>data.frame</code></td>
<td align="left">Split words</td>
</tr>
</tbody>
</table>

\****Note:*** *Text vector accompanied by aggregating `grouping.var`
argument, which can be in the form of a `vector`, `list`, or
`data.frame`*

Installation
============

To download the development version of **textshape**:

Download the [zip
ball](https://github.com/trinker/textshape/zipball/master) or [tar
ball](https://github.com/trinker/textshape/tarball/master), decompress
and run `R CMD INSTALL` on it, or use the **pacman** package to install
the development version:

    if (!require("pacman")) install.packages("pacman")
    pacman::p_load_gh("trinker/textshape")

Contact
=======

You are welcome to: 
* submit suggestions and bug-reports at: <https://github.com/trinker/textshape/issues> 
* send a pull request on: <https://github.com/trinker/textshape/> 
* compose a friendly e-mail to: <tyler.rinker@gmail.com>


Examples
========

The main shaping functions can be broken into the categories of (a)
combining, (b) tabulating, (c) spanning, & (d) splitting. The majority
of functions in **textshape** fall into the last category of splitting
and expanding (the semantic opposite of combining). These sections will
provide example uses of the functions from **textshape** within the
three categories.

Combining
---------

The `combine` function acts like `paste(x, collapse=" ")` on vectors and
lists of vectors. On dataframes multiple text cells are pasted together
within grouping variables.

#### A Vector

    x <- c("Computer", "is", "fun", ".", "Not", "too", "fun", ".")
    combine(x)

    ## [1] "Computer is fun. Not too fun."

#### A Dataframe

    (dat <- split_sentence(DATA))

    ##         person sex adult                       state code element_id
    ##  1:        sam   m     0            Computer is fun.   K1          1
    ##  2:        sam   m     0                Not too fun.   K1          1
    ##  3:       greg   m     0     No it's not, it's dumb.   K2          2
    ##  4:    teacher   m     1          What should we do?   K3          3
    ##  5:        sam   m     0        You liar, it stinks!   K4          4
    ##  6:       greg   m     0     I am telling the truth!   K5          5
    ##  7:      sally   f     0      How can we be certain?   K6          6
    ##  8:       greg   m     0            There is no way.   K7          7
    ##  9:        sam   m     0             I distrust you.   K8          8
    ## 10:      sally   f     0 What are you talking about?   K9          9
    ## 11: researcher   f     1           Shall we move on?  K10         10
    ## 12: researcher   f     1                  Good then.  K10         10
    ## 13:       greg   m     0                 I'm hungry.  K11         11
    ## 14:       greg   m     0                  Let's eat.  K11         11
    ## 15:       greg   m     0                You already?  K11         11
    ##     sentence_id
    ##  1:           1
    ##  2:           2
    ##  3:           1
    ##  4:           1
    ##  5:           1
    ##  6:           1
    ##  7:           1
    ##  8:           1
    ##  9:           1
    ## 10:           1
    ## 11:           1
    ## 12:           2
    ## 13:           1
    ## 14:           2
    ## 15:           3

    combine(dat[, 1:5, with=FALSE])

    ##         person sex adult                               state code
    ##  1:        sam   m     0       Computer is fun. Not too fun.   K1
    ##  2:       greg   m     0             No it's not, it's dumb.   K2
    ##  3:    teacher   m     1                  What should we do?   K3
    ##  4:        sam   m     0                You liar, it stinks!   K4
    ##  5:       greg   m     0             I am telling the truth!   K5
    ##  6:      sally   f     0              How can we be certain?   K6
    ##  7:       greg   m     0                    There is no way.   K7
    ##  8:        sam   m     0                     I distrust you.   K8
    ##  9:      sally   f     0         What are you talking about?   K9
    ## 10: researcher   f     1        Shall we move on? Good then.  K10
    ## 11:       greg   m     0 I'm hungry. Let's eat. You already?  K11

Tabulating
----------

`mtabulate` allows the user to transform data types into a dataframe of
counts.

#### A Vector

    (x <- list(w=letters[1:10], x=letters[1:5], z=letters))

    ## $w
    ##  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j"
    ## 
    ## $x
    ## [1] "a" "b" "c" "d" "e"
    ## 
    ## $z
    ##  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q"
    ## [18] "r" "s" "t" "u" "v" "w" "x" "y" "z"

    mtabulate(x)

    ##   a b c d e f g h i j k l m n o p q r s t u v w x y z
    ## w 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    ## x 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    ## z 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1

    ## Dummy coding
    mtabulate(mtcars$cyl[1:10])

    ##    4 6 8
    ## 1  0 1 0
    ## 2  0 1 0
    ## 3  1 0 0
    ## 4  0 1 0
    ## 5  0 0 1
    ## 6  0 1 0
    ## 7  0 0 1
    ## 8  1 0 0
    ## 9  1 0 0
    ## 10 0 1 0

#### A Dataframe

    (dat <- data.frame(matrix(sample(c("A", "B"), 30, TRUE), ncol=3)))

    ##    X1 X2 X3
    ## 1   B  B  A
    ## 2   A  A  A
    ## 3   A  B  B
    ## 4   B  A  B
    ## 5   A  B  A
    ## 6   A  B  B
    ## 7   A  A  B
    ## 8   A  B  B
    ## 9   A  A  B
    ## 10  B  A  A

    mtabulate(dat)

    ##    A B
    ## X1 7 3
    ## X2 5 5
    ## X3 4 6

    t(mtabulate(dat))

    ##   X1 X2 X3
    ## A  7  5  4
    ## B  3  5  6

Spanning
--------

Often it is useful to know the duration (start-end) of turns of talk.
The `duration` function calculations start-end durations as n words.

#### A Vector

    (x <- c(
        "Mr. Brown comes! He says hello. i give him coffee.",
        "I'll go at 5 p. m. eastern time.  Or somewhere in between!",
        "go there"
    ))

    ## [1] "Mr. Brown comes! He says hello. i give him coffee."        
    ## [2] "I'll go at 5 p. m. eastern time.  Or somewhere in between!"
    ## [3] "go there"

    duration(x)

    ##    all word.count start end
    ## 1: all         10     1  10
    ## 2: all         12    11  22
    ## 3: all          2    23  24
    ##                                                      text.var
    ## 1:         Mr. Brown comes! He says hello. i give him coffee.
    ## 2: I'll go at 5 p. m. eastern time.  Or somewhere in between!
    ## 3:                                                   go there

    # With grouping variables
    groups <- list(group1 = c("A", "B", "A"), group2 = c("red", "red", "green"))
    duration(x, groups)

    ##    group1 group2 word.count start end
    ## 1:      A    red         10     1  10
    ## 2:      B    red         12    11  22
    ## 3:      A  green          2    23  24
    ##                                                      text.var
    ## 1:         Mr. Brown comes! He says hello. i give him coffee.
    ## 2: I'll go at 5 p. m. eastern time.  Or somewhere in between!
    ## 3:                                                   go there

#### A Dataframe

    duration(DATA)

    ##         person sex adult code word.count start end
    ##  1:        sam   m     0   K1          6     1   6
    ##  2:       greg   m     0   K2          5     7  11
    ##  3:    teacher   m     1   K3          4    12  15
    ##  4:        sam   m     0   K4          4    16  19
    ##  5:       greg   m     0   K5          5    20  24
    ##  6:      sally   f     0   K6          5    25  29
    ##  7:       greg   m     0   K7          4    30  33
    ##  8:        sam   m     0   K8          3    34  36
    ##  9:      sally   f     0   K9          5    37  41
    ## 10: researcher   f     1  K10          6    42  47
    ## 11:       greg   m     0  K11          6    48  53
    ##                                     state
    ##  1:         Computer is fun. Not too fun.
    ##  2:               No it's not, it's dumb.
    ##  3:                    What should we do?
    ##  4:                  You liar, it stinks!
    ##  5:               I am telling the truth!
    ##  6:                How can we be certain?
    ##  7:                      There is no way.
    ##  8:                       I distrust you.
    ##  9:           What are you talking about?
    ## 10:         Shall we move on?  Good then.
    ## 11: I'm hungry.  Let's eat.  You already?

#### Gantt Plot

    library(ggplot2)
    ggplot(duration(DATA), aes(x = start, xend = end, y = person, yend = person, color = sex)) +
        geom_segment(size=4) +
        xlab("Duration (Words)") +
        ylab("Person")

![](inst/figure/unnamed-chunk-9-1.png)

Splitting
---------

The following section provides examples of available splitting
functions.

### Indices

`split_index` allows the user to supply the integer indices of where to
split a data type.

#### A Vector

    split_index(LETTERS, c(4, 10, 16), c("dog", "cat", "chicken", "rabbit"))

    ## $dog
    ## [1] "A" "B" "C"
    ## 
    ## $cat
    ## [1] "D" "E" "F" "G" "H" "I"
    ## 
    ## $chicken
    ## [1] "J" "K" "L" "M" "N" "O"
    ## 
    ## $rabbit
    ##  [1] "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"

#### A Dataframe

Here I calculate the indices of every time the `vs` variable in the
`mtcars` data set changes and then split the dataframe on those indices.

    (vs_change <- head(1 + cumsum(rle(as.character(mtcars[["vs"]]))[[1]]), -1))

    ##  [1]  3  5  6  7  8 12 18 22 26 27 28 29 32

    split_index(mtcars, vs_change)

    ## [[1]]
    ##               mpg cyl disp  hp drat    wt  qsec vs am gear carb
    ## Mazda RX4      21   6  160 110  3.9 2.620 16.46  0  1    4    4
    ## Mazda RX4 Wag  21   6  160 110  3.9 2.875 17.02  0  1    4    4
    ## 
    ## [[2]]
    ##                 mpg cyl disp  hp drat    wt  qsec vs am gear carb
    ## Datsun 710     22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
    ## Hornet 4 Drive 21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
    ## 
    ## [[3]]
    ##                    mpg cyl disp  hp drat   wt  qsec vs am gear carb
    ## Hornet Sportabout 18.7   8  360 175 3.15 3.44 17.02  0  0    3    2
    ## 
    ## [[4]]
    ##          mpg cyl disp  hp drat   wt  qsec vs am gear carb
    ## Valiant 18.1   6  225 105 2.76 3.46 20.22  1  0    3    1
    ## 
    ## [[5]]
    ##             mpg cyl disp  hp drat   wt  qsec vs am gear carb
    ## Duster 360 14.3   8  360 245 3.21 3.57 15.84  0  0    3    4
    ## 
    ## [[6]]
    ##            mpg cyl  disp  hp drat   wt qsec vs am gear carb
    ## Merc 240D 24.4   4 146.7  62 3.69 3.19 20.0  1  0    4    2
    ## Merc 230  22.8   4 140.8  95 3.92 3.15 22.9  1  0    4    2
    ## Merc 280  19.2   6 167.6 123 3.92 3.44 18.3  1  0    4    4
    ## Merc 280C 17.8   6 167.6 123 3.92 3.44 18.9  1  0    4    4
    ## 
    ## [[7]]
    ##                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb
    ## Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
    ## Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
    ## Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
    ## Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
    ## Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
    ## Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
    ## 
    ## [[8]]
    ##                 mpg cyl  disp hp drat    wt  qsec vs am gear carb
    ## Fiat 128       32.4   4  78.7 66 4.08 2.200 19.47  1  1    4    1
    ## Honda Civic    30.4   4  75.7 52 4.93 1.615 18.52  1  1    4    2
    ## Toyota Corolla 33.9   4  71.1 65 4.22 1.835 19.90  1  1    4    1
    ## Toyota Corona  21.5   4 120.1 97 3.70 2.465 20.01  1  0    3    1
    ## 
    ## [[9]]
    ##                   mpg cyl disp  hp drat    wt  qsec vs am gear carb
    ## Dodge Challenger 15.5   8  318 150 2.76 3.520 16.87  0  0    3    2
    ## AMC Javelin      15.2   8  304 150 3.15 3.435 17.30  0  0    3    2
    ## Camaro Z28       13.3   8  350 245 3.73 3.840 15.41  0  0    3    4
    ## Pontiac Firebird 19.2   8  400 175 3.08 3.845 17.05  0  0    3    2
    ## 
    ## [[10]]
    ##            mpg cyl disp hp drat    wt qsec vs am gear carb
    ## Fiat X1-9 27.3   4   79 66 4.08 1.935 18.9  1  1    4    1
    ## 
    ## [[11]]
    ##               mpg cyl  disp hp drat   wt qsec vs am gear carb
    ## Porsche 914-2  26   4 120.3 91 4.43 2.14 16.7  0  1    5    2
    ## 
    ## [[12]]
    ##               mpg cyl disp  hp drat    wt qsec vs am gear carb
    ## Lotus Europa 30.4   4 95.1 113 3.77 1.513 16.9  1  1    5    2
    ## 
    ## [[13]]
    ##                 mpg cyl disp  hp drat   wt qsec vs am gear carb
    ## Ford Pantera L 15.8   8  351 264 4.22 3.17 14.5  0  1    5    4
    ## Ferrari Dino   19.7   6  145 175 3.62 2.77 15.5  0  1    5    6
    ## Maserati Bora  15.0   8  301 335 3.54 3.57 14.6  0  1    5    8
    ## 
    ## [[14]]
    ##             mpg cyl disp  hp drat   wt qsec vs am gear carb
    ## Volvo 142E 21.4   4  121 109 4.11 2.78 18.6  1  1    4    2

### Matches

`split_match` splits on elements that match exactly or via a regular
expression match.

#### Exact Match

    set.seed(15)
    (x <- sample(c("", LETTERS[1:10]), 25, TRUE, prob=c(.2, rep(.08, 10))))

    ##  [1] "C" ""  "A" "C" "D" "A" "I" "B" "H" "I" ""  "C" "E" "H" "J" "J" "E"
    ## [18] "A" ""  "I" "I" "I" "G" ""  "F"

    split_match(x)

    ## $`1`
    ## [1] "C"
    ## 
    ## $`2`
    ## [1] "A" "C" "D" "A" "I" "B" "H" "I"
    ## 
    ## $`3`
    ## [1] "C" "E" "H" "J" "J" "E" "A"
    ## 
    ## $`4`
    ## [1] "I" "I" "I" "G"
    ## 
    ## $`5`
    ## [1] "F"

    split_match(x, "C")

    ## $`1`
    ## [1] ""  "A"
    ## 
    ## $`2`
    ## [1] "D" "A" "I" "B" "H" "I" "" 
    ## 
    ## $`3`
    ##  [1] "E" "H" "J" "J" "E" "A" ""  "I" "I" "I" "G" ""  "F"

    split_match(x, c("", "C"))

    ## $`1`
    ## [1] "A"
    ## 
    ## $`2`
    ## [1] "D" "A" "I" "B" "H" "I"
    ## 
    ## $`3`
    ## [1] "E" "H" "J" "J" "E" "A"
    ## 
    ## $`4`
    ## [1] "I" "I" "I" "G"
    ## 
    ## $`5`
    ## [1] "F"

    ## Don't include
    split_match(x, include = 0)

    ## $`1`
    ## [1] "C"
    ## 
    ## $`2`
    ## [1] "A" "C" "D" "A" "I" "B" "H" "I"
    ## 
    ## $`3`
    ## [1] "C" "E" "H" "J" "J" "E" "A"
    ## 
    ## $`4`
    ## [1] "I" "I" "I" "G"
    ## 
    ## $`5`
    ## [1] "F"

    ## Include at beginning
    split_match(x, include = 1)

    ## $`1`
    ## [1] "C"
    ## 
    ## $`2`
    ## [1] ""  "A" "C" "D" "A" "I" "B" "H" "I"
    ## 
    ## $`3`
    ## [1] ""  "C" "E" "H" "J" "J" "E" "A"
    ## 
    ## $`4`
    ## [1] ""  "I" "I" "I" "G"
    ## 
    ## $`5`
    ## [1] ""  "F"

    ## Include at end
    split_match(x, include = 2)

    ## [[1]]
    ## [1] "C" "" 
    ## 
    ## [[2]]
    ## [1] "A" "C" "D" "A" "I" "B" "H" "I" "" 
    ## 
    ## [[3]]
    ## [1] "C" "E" "H" "J" "J" "E" "A" "" 
    ## 
    ## [[4]]
    ## [1] "I" "I" "I" "G" "" 
    ## 
    ## [[5]]
    ## [1] "F"

#### Regex Match

Here I use the regex `"^I"` to break on any vectors containing the
capital letter I as the first character.

    split_match(DATA[["state"]], "^I", regex=TRUE, include = 1)

    ## $`1`
    ## [1] "Computer is fun. Not too fun." "No it's not, it's dumb."      
    ## [3] "What should we do?"            "You liar, it stinks!"         
    ## 
    ## $`2`
    ## [1] "I am telling the truth!" "How can we be certain?" 
    ## [3] "There is no way."       
    ## 
    ## $`3`
    ## [1] "I distrust you."               "What are you talking about?"  
    ## [3] "Shall we move on?  Good then."
    ## 
    ## $`4`
    ## [1] "I'm hungry.  Let's eat.  You already?"

### Portions

At times it is useful to split texts into portioned chunks, operate on
the chunks and aggregate the results. `split_portion` allows the user to
do this sort of text shaping. We can split into n chunks per grouping
variable (via `n.chunks`) or into chunks of n length (via `n.words`).

#### A Vector

    with(DATA, split_portion(state, n.chunks = 10))

    ##     all index                     text.var
    ##  1: all     1     Computer is fun. Not too
    ##  2: all     2       fun. No it's not, it's
    ##  3: all     3     dumb. What should we do?
    ##  4: all     4       You liar, it stinks! I
    ##  5: all     5    am telling the truth! How
    ##  6: all     6     can we be certain? There
    ##  7: all     7        is no way. I distrust
    ##  8: all     8    you. What are you talking
    ##  9: all     9     about? Shall we move on?
    ## 10: all    10 Good then. I'm hungry. Let's
    ## 11: all    11            eat. You already?

    with(DATA, split_portion(state, n.words = 10))

    ##    all index                                              text.var
    ## 1: all     1       Computer is fun. Not too fun. No it's not, it's
    ## 2: all     2       dumb. What should we do? You liar, it stinks! I
    ## 3: all     3    am telling the truth! How can we be certain? There
    ## 4: all     4       is no way. I distrust you. What are you talking
    ## 5: all     5 about? Shall we move on? Good then. I'm hungry. Let's
    ## 6: all     6                                     eat. You already?

#### A Dataframe

    with(DATA, split_portion(state, list(sex, adult), n.words = 10))

    ##    sex adult index                                           text.var
    ## 1:   f     0     1 How can we be certain? What are you talking about?
    ## 2:   f     1     1                       Shall we move on? Good then.
    ## 3:   m     0     1    Computer is fun. Not too fun. No it's not, it's
    ## 4:   m     0     2 dumb. You liar, it stinks! I am telling the truth!
    ## 5:   m     0     3 There is no way. I distrust you. I'm hungry. Let's
    ## 6:   m     0     4                                  eat. You already?
    ## 7:   m     1     1                                 What should we do?

### Runs

`split_run` allows the user to split up runs of identical characters.

    x1 <- c(
         "122333444455555666666",
         NA,
         "abbcccddddeeeeeffffff",
         "sddfg",
         "11112222333"
    )

    x <- c(rep(x1, 2), ">>???,,,,....::::;[[")

    split_run(x)

    ## [[1]]
    ## [1] "1"      "22"     "333"    "4444"   "55555"  "666666" ""      
    ## 
    ## [[2]]
    ## [1] NA
    ## 
    ## [[3]]
    ## [1] "a"      "bb"     "ccc"    "dddd"   "eeeee"  "ffffff" ""      
    ## 
    ## [[4]]
    ## [1] "s"  "dd" "f"  "g"  ""  
    ## 
    ## [[5]]
    ## [1] "1111" "2222" "333"  ""    
    ## 
    ## [[6]]
    ## [1] "1"      "22"     "333"    "4444"   "55555"  "666666" ""      
    ## 
    ## [[7]]
    ## [1] NA
    ## 
    ## [[8]]
    ## [1] "a"      "bb"     "ccc"    "dddd"   "eeeee"  "ffffff" ""      
    ## 
    ## [[9]]
    ## [1] "s"  "dd" "f"  "g"  ""  
    ## 
    ## [[10]]
    ## [1] "1111" "2222" "333"  ""    
    ## 
    ## [[11]]
    ## [1] ">>???,,,,....::::;[["

#### Dataframe

    DATA[["run.col"]] <- x
    split_run(DATA)

    ##         person sex adult                                 state code
    ##  1:        sam   m     0         Computer is fun. Not too fun.   K1
    ##  2:        sam   m     0         Computer is fun. Not too fun.   K1
    ##  3:        sam   m     0         Computer is fun. Not too fun.   K1
    ##  4:        sam   m     0         Computer is fun. Not too fun.   K1
    ##  5:        sam   m     0         Computer is fun. Not too fun.   K1
    ##  6:        sam   m     0         Computer is fun. Not too fun.   K1
    ##  7:        sam   m     0         Computer is fun. Not too fun.   K1
    ##  8:       greg   m     0               No it's not, it's dumb.   K2
    ##  9:    teacher   m     1                    What should we do?   K3
    ## 10:    teacher   m     1                    What should we do?   K3
    ## 11:    teacher   m     1                    What should we do?   K3
    ## 12:    teacher   m     1                    What should we do?   K3
    ## 13:    teacher   m     1                    What should we do?   K3
    ## 14:    teacher   m     1                    What should we do?   K3
    ## 15:    teacher   m     1                    What should we do?   K3
    ## 16:        sam   m     0                  You liar, it stinks!   K4
    ## 17:        sam   m     0                  You liar, it stinks!   K4
    ## 18:        sam   m     0                  You liar, it stinks!   K4
    ## 19:        sam   m     0                  You liar, it stinks!   K4
    ## 20:        sam   m     0                  You liar, it stinks!   K4
    ## 21:       greg   m     0               I am telling the truth!   K5
    ## 22:       greg   m     0               I am telling the truth!   K5
    ## 23:       greg   m     0               I am telling the truth!   K5
    ## 24:       greg   m     0               I am telling the truth!   K5
    ## 25:      sally   f     0                How can we be certain?   K6
    ## 26:      sally   f     0                How can we be certain?   K6
    ## 27:      sally   f     0                How can we be certain?   K6
    ## 28:      sally   f     0                How can we be certain?   K6
    ## 29:      sally   f     0                How can we be certain?   K6
    ## 30:      sally   f     0                How can we be certain?   K6
    ## 31:      sally   f     0                How can we be certain?   K6
    ## 32:       greg   m     0                      There is no way.   K7
    ## 33:        sam   m     0                       I distrust you.   K8
    ## 34:        sam   m     0                       I distrust you.   K8
    ## 35:        sam   m     0                       I distrust you.   K8
    ## 36:        sam   m     0                       I distrust you.   K8
    ## 37:        sam   m     0                       I distrust you.   K8
    ## 38:        sam   m     0                       I distrust you.   K8
    ## 39:        sam   m     0                       I distrust you.   K8
    ## 40:      sally   f     0           What are you talking about?   K9
    ## 41:      sally   f     0           What are you talking about?   K9
    ## 42:      sally   f     0           What are you talking about?   K9
    ## 43:      sally   f     0           What are you talking about?   K9
    ## 44:      sally   f     0           What are you talking about?   K9
    ## 45: researcher   f     1         Shall we move on?  Good then.  K10
    ## 46: researcher   f     1         Shall we move on?  Good then.  K10
    ## 47: researcher   f     1         Shall we move on?  Good then.  K10
    ## 48: researcher   f     1         Shall we move on?  Good then.  K10
    ## 49:       greg   m     0 I'm hungry.  Let's eat.  You already?  K11
    ##         person sex adult                                 state code
    ##                  run.col element_id sentence_id
    ##  1:                    1          1           1
    ##  2:                   22          1           2
    ##  3:                  333          1           3
    ##  4:                 4444          1           4
    ##  5:                55555          1           5
    ##  6:               666666          1           6
    ##  7:                               1           7
    ##  8:                   NA          2           1
    ##  9:                    a          3           1
    ## 10:                   bb          3           2
    ## 11:                  ccc          3           3
    ## 12:                 dddd          3           4
    ## 13:                eeeee          3           5
    ## 14:               ffffff          3           6
    ## 15:                               3           7
    ## 16:                    s          4           1
    ## 17:                   dd          4           2
    ## 18:                    f          4           3
    ## 19:                    g          4           4
    ## 20:                               4           5
    ## 21:                 1111          5           1
    ## 22:                 2222          5           2
    ## 23:                  333          5           3
    ## 24:                               5           4
    ## 25:                    1          6           1
    ## 26:                   22          6           2
    ## 27:                  333          6           3
    ## 28:                 4444          6           4
    ## 29:                55555          6           5
    ## 30:               666666          6           6
    ## 31:                               6           7
    ## 32:                   NA          7           1
    ## 33:                    a          8           1
    ## 34:                   bb          8           2
    ## 35:                  ccc          8           3
    ## 36:                 dddd          8           4
    ## 37:                eeeee          8           5
    ## 38:               ffffff          8           6
    ## 39:                               8           7
    ## 40:                    s          9           1
    ## 41:                   dd          9           2
    ## 42:                    f          9           3
    ## 43:                    g          9           4
    ## 44:                               9           5
    ## 45:                 1111         10           1
    ## 46:                 2222         10           2
    ## 47:                  333         10           3
    ## 48:                              10           4
    ## 49: >>???,,,,....::::;[[         11           1
    ##                  run.col element_id sentence_id

    ## Reset the DATA dataset
    DATA <- textshape::DATA

### Sentences

`split_sentece` provides a mapping + regex approach to splitting
sentences. It is less accurate than the Stanford parser but more
accurate than a simple regular expression approach alone.

#### A Vector

    (x <- paste0(
        "Mr. Brown comes! He says hello. i give him coffee.  i will ",
        "go at 5 p. m. eastern time.  Or somewhere in between!go there"
    ))

    ## [1] "Mr. Brown comes! He says hello. i give him coffee.  i will go at 5 p. m. eastern time.  Or somewhere in between!go there"

    split_sentence(x)

    ## [[1]]
    ## [1] "Mr. Brown comes!"                  "He says hello."                   
    ## [3] "i give him coffee."                "i will go at 5 p.m. eastern time."
    ## [5] "Or somewhere in between!"          "go there"

#### A Dataframe

    split_sentence(DATA)

    ##         person sex adult                       state code element_id
    ##  1:        sam   m     0            Computer is fun.   K1          1
    ##  2:        sam   m     0                Not too fun.   K1          1
    ##  3:       greg   m     0     No it's not, it's dumb.   K2          2
    ##  4:    teacher   m     1          What should we do?   K3          3
    ##  5:        sam   m     0        You liar, it stinks!   K4          4
    ##  6:       greg   m     0     I am telling the truth!   K5          5
    ##  7:      sally   f     0      How can we be certain?   K6          6
    ##  8:       greg   m     0            There is no way.   K7          7
    ##  9:        sam   m     0             I distrust you.   K8          8
    ## 10:      sally   f     0 What are you talking about?   K9          9
    ## 11: researcher   f     1           Shall we move on?  K10         10
    ## 12: researcher   f     1                  Good then.  K10         10
    ## 13:       greg   m     0                 I'm hungry.  K11         11
    ## 14:       greg   m     0                  Let's eat.  K11         11
    ## 15:       greg   m     0                You already?  K11         11
    ##     sentence_id
    ##  1:           1
    ##  2:           2
    ##  3:           1
    ##  4:           1
    ##  5:           1
    ##  6:           1
    ##  7:           1
    ##  8:           1
    ##  9:           1
    ## 10:           1
    ## 11:           1
    ## 12:           2
    ## 13:           1
    ## 14:           2
    ## 15:           3

### Speakers

Often speakers may talk in unison. This is often displayed in a single
cell as a comma separated string of speakers. Some analysis may require
this information to be parsed out and replicated as one turn per
speaker. The `split_speaker` function accomplishes this.

    DATA$person <- as.character(DATA$person)
    DATA$person[c(1, 4, 6)] <- c("greg, sally, & sam",
        "greg, sally", "sam and sally")
    DATA

    ##                person sex adult                                 state code
    ## 1  greg, sally, & sam   m     0         Computer is fun. Not too fun.   K1
    ## 2                greg   m     0               No it's not, it's dumb.   K2
    ## 3             teacher   m     1                    What should we do?   K3
    ## 4         greg, sally   m     0                  You liar, it stinks!   K4
    ## 5                greg   m     0               I am telling the truth!   K5
    ## 6       sam and sally   f     0                How can we be certain?   K6
    ## 7                greg   m     0                      There is no way.   K7
    ## 8                 sam   m     0                       I distrust you.   K8
    ## 9               sally   f     0           What are you talking about?   K9
    ## 10         researcher   f     1         Shall we move on?  Good then.  K10
    ## 11               greg   m     0 I'm hungry.  Let's eat.  You already?  K11

    split_speaker(DATA)

    ##         person sex adult                                 state code
    ##  1:       greg   m     0         Computer is fun. Not too fun.   K1
    ##  2:      sally   m     0         Computer is fun. Not too fun.   K1
    ##  3:        sam   m     0         Computer is fun. Not too fun.   K1
    ##  4:       greg   m     0               No it's not, it's dumb.   K2
    ##  5:    teacher   m     1                    What should we do?   K3
    ##  6:       greg   m     0                  You liar, it stinks!   K4
    ##  7:      sally   m     0                  You liar, it stinks!   K4
    ##  8:       greg   m     0               I am telling the truth!   K5
    ##  9:        sam   f     0                How can we be certain?   K6
    ## 10:      sally   f     0                How can we be certain?   K6
    ## 11:       greg   m     0                      There is no way.   K7
    ## 12:        sam   m     0                       I distrust you.   K8
    ## 13:      sally   f     0           What are you talking about?   K9
    ## 14: researcher   f     1         Shall we move on?  Good then.  K10
    ## 15:       greg   m     0 I'm hungry.  Let's eat.  You already?  K11
    ##     element_id split_id
    ##  1:          1        1
    ##  2:          1        2
    ##  3:          1        3
    ##  4:          2        1
    ##  5:          3        1
    ##  6:          4        1
    ##  7:          4        2
    ##  8:          5        1
    ##  9:          6        1
    ## 10:          6        2
    ## 11:          7        1
    ## 12:          8        1
    ## 13:          9        1
    ## 14:         10        1
    ## 15:         11        1

    ## Reset the DATA dataset
    DATA <- textshape::DATA

### Tokens

The `split_token` function split data into words and punctuation.

#### A Vector

    (x <- c(
        "Mr. Brown comes! He says hello. i give him coffee.",
        "I'll go at 5 p. m. eastern time.  Or somewhere in between!",
        "go there"
    ))

    ## [1] "Mr. Brown comes! He says hello. i give him coffee."        
    ## [2] "I'll go at 5 p. m. eastern time.  Or somewhere in between!"
    ## [3] "go there"

    split_token(x)

    ## [[1]]
    ##  [1] "mr"     "."      "brown"  "comes"  "!"      "he"     "says"  
    ##  [8] "hello"  "."      "i"      "give"   "him"    "coffee" "."     
    ## 
    ## [[2]]
    ##  [1] "i'll"      "go"        "at"        "5"         "p"        
    ##  [6] "."         "m"         "."         "eastern"   "time"     
    ## [11] "."         "or"        "somewhere" "in"        "between"  
    ## [16] "!"        
    ## 
    ## [[3]]
    ## [1] "go"    "there"

#### A Dataframe

     split_token(DATA)

    ##         person sex adult    state code element_id sentence_id
    ##  1:        sam   m     0 computer   K1          1           1
    ##  2:        sam   m     0       is   K1          1           2
    ##  3:        sam   m     0      fun   K1          1           3
    ##  4:        sam   m     0        .   K1          1           4
    ##  5:        sam   m     0      not   K1          1           5
    ##  6:        sam   m     0      too   K1          1           6
    ##  7:        sam   m     0      fun   K1          1           7
    ##  8:        sam   m     0        .   K1          1           8
    ##  9:       greg   m     0       no   K2          2           1
    ## 10:       greg   m     0     it's   K2          2           2
    ## 11:       greg   m     0      not   K2          2           3
    ## 12:       greg   m     0        ,   K2          2           4
    ## 13:       greg   m     0     it's   K2          2           5
    ## 14:       greg   m     0     dumb   K2          2           6
    ## 15:       greg   m     0        .   K2          2           7
    ## 16:    teacher   m     1     what   K3          3           1
    ## 17:    teacher   m     1   should   K3          3           2
    ## 18:    teacher   m     1       we   K3          3           3
    ## 19:    teacher   m     1       do   K3          3           4
    ## 20:    teacher   m     1        ?   K3          3           5
    ## 21:        sam   m     0      you   K4          4           1
    ## 22:        sam   m     0     liar   K4          4           2
    ## 23:        sam   m     0        ,   K4          4           3
    ## 24:        sam   m     0       it   K4          4           4
    ## 25:        sam   m     0   stinks   K4          4           5
    ## 26:        sam   m     0        !   K4          4           6
    ## 27:       greg   m     0        i   K5          5           1
    ## 28:       greg   m     0       am   K5          5           2
    ## 29:       greg   m     0  telling   K5          5           3
    ## 30:       greg   m     0      the   K5          5           4
    ## 31:       greg   m     0    truth   K5          5           5
    ## 32:       greg   m     0        !   K5          5           6
    ## 33:      sally   f     0      how   K6          6           1
    ## 34:      sally   f     0      can   K6          6           2
    ## 35:      sally   f     0       we   K6          6           3
    ## 36:      sally   f     0       be   K6          6           4
    ## 37:      sally   f     0  certain   K6          6           5
    ## 38:      sally   f     0        ?   K6          6           6
    ## 39:       greg   m     0    there   K7          7           1
    ## 40:       greg   m     0       is   K7          7           2
    ## 41:       greg   m     0       no   K7          7           3
    ## 42:       greg   m     0      way   K7          7           4
    ## 43:       greg   m     0        .   K7          7           5
    ## 44:        sam   m     0        i   K8          8           1
    ## 45:        sam   m     0 distrust   K8          8           2
    ## 46:        sam   m     0      you   K8          8           3
    ## 47:        sam   m     0        .   K8          8           4
    ## 48:      sally   f     0     what   K9          9           1
    ## 49:      sally   f     0      are   K9          9           2
    ## 50:      sally   f     0      you   K9          9           3
    ## 51:      sally   f     0  talking   K9          9           4
    ## 52:      sally   f     0    about   K9          9           5
    ## 53:      sally   f     0        ?   K9          9           6
    ## 54: researcher   f     1    shall  K10         10           1
    ## 55: researcher   f     1       we  K10         10           2
    ## 56: researcher   f     1     move  K10         10           3
    ## 57: researcher   f     1       on  K10         10           4
    ## 58: researcher   f     1        ?  K10         10           5
    ## 59: researcher   f     1     good  K10         10           6
    ## 60: researcher   f     1     then  K10         10           7
    ## 61: researcher   f     1        .  K10         10           8
    ## 62:       greg   m     0      i'm  K11         11           1
    ## 63:       greg   m     0   hungry  K11         11           2
    ## 64:       greg   m     0        .  K11         11           3
    ## 65:       greg   m     0    let's  K11         11           4
    ## 66:       greg   m     0      eat  K11         11           5
    ## 67:       greg   m     0        .  K11         11           6
    ## 68:       greg   m     0      you  K11         11           7
    ## 69:       greg   m     0  already  K11         11           8
    ## 70:       greg   m     0        ?  K11         11           9
    ##         person sex adult    state code element_id sentence_id

### Words

The `split_word` function split data into words.

#### A Vector

    (x <- c(
        "Mr. Brown comes! He says hello. i give him coffee.",
        "I'll go at 5 p. m. eastern time.  Or somewhere in between!",
        "go there"
    ))

    ## [1] "Mr. Brown comes! He says hello. i give him coffee."        
    ## [2] "I'll go at 5 p. m. eastern time.  Or somewhere in between!"
    ## [3] "go there"

    split_word(x)

    ## [[1]]
    ##  [1] "mr"     "brown"  "comes"  "he"     "says"   "hello"  "i"     
    ##  [8] "give"   "him"    "coffee"
    ## 
    ## [[2]]
    ##  [1] "i'll"      "go"        "at"        "5"         "p"        
    ##  [6] "m"         "eastern"   "time"      "or"        "somewhere"
    ## [11] "in"        "between"  
    ## 
    ## [[3]]
    ## [1] "go"    "there"

#### A Dataframe

     split_word(DATA)

    ##         person sex adult    state code element_id sentence_id
    ##  1:        sam   m     0 computer   K1          1           1
    ##  2:        sam   m     0       is   K1          1           2
    ##  3:        sam   m     0      fun   K1          1           3
    ##  4:        sam   m     0      not   K1          1           4
    ##  5:        sam   m     0      too   K1          1           5
    ##  6:        sam   m     0      fun   K1          1           6
    ##  7:       greg   m     0       no   K2          2           1
    ##  8:       greg   m     0     it's   K2          2           2
    ##  9:       greg   m     0      not   K2          2           3
    ## 10:       greg   m     0     it's   K2          2           4
    ## 11:       greg   m     0     dumb   K2          2           5
    ## 12:    teacher   m     1     what   K3          3           1
    ## 13:    teacher   m     1   should   K3          3           2
    ## 14:    teacher   m     1       we   K3          3           3
    ## 15:    teacher   m     1       do   K3          3           4
    ## 16:        sam   m     0      you   K4          4           1
    ## 17:        sam   m     0     liar   K4          4           2
    ## 18:        sam   m     0       it   K4          4           3
    ## 19:        sam   m     0   stinks   K4          4           4
    ## 20:       greg   m     0        i   K5          5           1
    ## 21:       greg   m     0       am   K5          5           2
    ## 22:       greg   m     0  telling   K5          5           3
    ## 23:       greg   m     0      the   K5          5           4
    ## 24:       greg   m     0    truth   K5          5           5
    ## 25:      sally   f     0      how   K6          6           1
    ## 26:      sally   f     0      can   K6          6           2
    ## 27:      sally   f     0       we   K6          6           3
    ## 28:      sally   f     0       be   K6          6           4
    ## 29:      sally   f     0  certain   K6          6           5
    ## 30:       greg   m     0    there   K7          7           1
    ## 31:       greg   m     0       is   K7          7           2
    ## 32:       greg   m     0       no   K7          7           3
    ## 33:       greg   m     0      way   K7          7           4
    ## 34:        sam   m     0        i   K8          8           1
    ## 35:        sam   m     0 distrust   K8          8           2
    ## 36:        sam   m     0      you   K8          8           3
    ## 37:      sally   f     0     what   K9          9           1
    ## 38:      sally   f     0      are   K9          9           2
    ## 39:      sally   f     0      you   K9          9           3
    ## 40:      sally   f     0  talking   K9          9           4
    ## 41:      sally   f     0    about   K9          9           5
    ## 42: researcher   f     1    shall  K10         10           1
    ## 43: researcher   f     1       we  K10         10           2
    ## 44: researcher   f     1     move  K10         10           3
    ## 45: researcher   f     1       on  K10         10           4
    ## 46: researcher   f     1     good  K10         10           5
    ## 47: researcher   f     1     then  K10         10           6
    ## 48:       greg   m     0      i'm  K11         11           1
    ## 49:       greg   m     0   hungry  K11         11           2
    ## 50:       greg   m     0    let's  K11         11           3
    ## 51:       greg   m     0      eat  K11         11           4
    ## 52:       greg   m     0      you  K11         11           5
    ## 53:       greg   m     0  already  K11         11           6
    ##         person sex adult    state code element_id sentence_id