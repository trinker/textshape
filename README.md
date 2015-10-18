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

Functions
=========

Most of the functions split/expand a `vector`, `list` or `data.frame`.
The `combine` and `mtabulate` functions are notable exceptions. The
table below describes the functions and their use:

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
<td align="left"><code>mtabulate</code></td>
<td align="left"><code>vector</code>, <code>list</code>, <code>data.frame</code></td>
<td align="left">Vectorize version of <code>tabulate</code> to produce count matrix</td>
</tr>
<tr class="odd">
<td align="left"><code>split_index</code></td>
<td align="left"><code>vector</code>, <code>list</code>, <code>data.frame</code></td>
<td align="left">Split data a specified indices</td>
</tr>
<tr class="even">
<td align="left"><code>split_match</code></td>
<td align="left"><code>vector</code></td>
<td align="left">Split vector at specified character/regex</td>
</tr>
<tr class="odd">
<td align="left"><code>split_portion</code></td>
<td align="left"><code>vector</code>*</td>
<td align="left">Split data into portioned chunks</td>
</tr>
<tr class="even">
<td align="left"><code>split_run</code></td>
<td align="left"><code>vector</code>, <code>data.frame</code></td>
<td align="left">Split runs (e.g., &quot;aaabbbbcdddd&quot;)</td>
</tr>
<tr class="odd">
<td align="left"><code>split_sentence</code></td>
<td align="left"><code>vector</code>, <code>data.frame</code></td>
<td align="left">Split sentences</td>
</tr>
<tr class="even">
<td align="left"><code>split_speaker</code></td>
<td align="left"><code>data.frame</code></td>
<td align="left">Split combined speakers (e.g., &quot;Josh, Jake, Jim&quot;)</td>
</tr>
<tr class="odd">
<td align="left"><code>split_token</code></td>
<td align="left"><code>vector</code>, <code>data.frame</code></td>
<td align="left">Split words and punctuation</td>
</tr>
<tr class="even">
<td align="left"><code>split_word</code></td>
<td align="left"><code>vector</code>, <code>data.frame</code></td>
<td align="left">Split words</td>
</tr>
</tbody>
</table>

\****Note:*** *Text vector accompanied by aggregating `grouping.var`
argument, which can be in the form of a `vector`, `list`, or
`data.frame`*


Table of Contents
============

-   [Functions](#functions)
-   [Installation](#installation)
-   [Contact](#contact)
-   [Examples](#examples)

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