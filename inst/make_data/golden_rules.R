pacman::p_load(textshape, textclean, tidyverse, stringi, magrittr)

golden_rules <- 'https://s3.amazonaws.com/tm-town-nlp-resources/golden_rules.txt' %>%
    readLines() %>%
    `[`(3:197) %>%
    # drop_element('^\\s*$') %>%
    split_match('^\\s*$', FALSE, TRUE) %>%
    map(function(x){

        tibble::tibble(
            Rule = x %>%
                `[`(1) %>%
                stringi::stri_replace_all_regex('^\\d+\\)\\s*', '') %>%
                trimws(),
            Text = x[2],
            Outcome = x %>%
                `[`(3) %>%
                stringi::stri_replace_all_regex('^\\[', 'c(') %>%
                stringi::stri_replace_all_regex('\\]$', ')') %>%
                {parse(text = .)} %>%
                eval()
        )
    }) %>%
    bind_rows() %>%
    nest(-c(Rule, Text), .key = Outcome) %>%
    filter(!grepl("[^ -~]", Text))

# golden_rules %$%
#     split_sentence(Text)

# pax::new_data(golden_rules)
#golden_rules$Text
