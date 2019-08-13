# This script recalls a general function (articulated in more calls) for the shiny app



# Load Training Data, created by `04A_Task_Script.R`
words_2 <- readRDS("./words_2_opt.rds")
words_3  <- readRDS("./words_3_opt.rds")
words_4 <- readRDS("./words_4_opt.rds")

# Create rthe functions to determine the N-rams
gram_2 <- function(introduced_words){
  number_of_words <- length(introduced_words)
  filter(words_2, 
         word1==introduced_words[number_of_words]) %>% 
    top_n(1, n) %>%
    filter(row_number() == 1L) %>%
    select(num_range("word", 2)) %>%
    as.character() -> value
  ifelse(value =="character(0)", "?", return(value))
}

gram_3 <- function(introduced_words){
  number_of_words <- length(introduced_words)
  filter(words_3, 
         word1==introduced_words[number_of_words-1], 
         word2==introduced_words[number_of_words])  %>% 
    top_n(1, n) %>%
    filter(row_number() == 1L) %>%
    select(num_range("word", 3)) %>%
    as.character() -> value
  ifelse(value=="character(0)", gram_2(introduced_words), return(value))
}

gram_4 <- function(introduced_words){
  number_of_words <- length(introduced_words)
  filter(words_4, 
         word1==introduced_words[number_of_words-2], 
         word2==introduced_words[number_of_words-1], 
         word3==introduced_words[number_of_words])  %>% 
    top_n(1, n) %>%
    filter(row_number() == 1L) %>%
    select(num_range("word", 4)) %>%
    as.character() -> value
  ifelse(value=="character(0)", gram_3(introduced_words), return(value))
}

# General master (it calls the proper function according to the case)
gram_n <- function(input){

  my_input <- data_frame(text = input)
 
   # perform some cleaning
  replace_reg <- "[^[:alpha:][:space:]]*"
  my_input <- my_input %>% mutate(text = str_replace_all(text, replace_reg, ""))
  # split the introduced words
  how_many <- str_count(my_input, boundary("word"))
  introduced_words <- unlist(str_split(my_input, boundary("word")))
  introduced_words <- tolower(introduced_words)
  # depending on how_many value, we call the corresponding function
  value <- ifelse(how_many == 0, "Introduce the phrase",
                ifelse(how_many == 3, gram_4(introduced_words),
                       ifelse(how_many == 2, gram_3(introduced_words), gram_2(introduced_words))))
  
  # Output
  return(value)
}