################################################################################
##                          Class Project                                     ##
################################################################################

# This class project is to test your knowledge of SELECT statement

################################################################################
##                                  PopRunner caselet                         ##
################################################################################

# This script is based on the PopRunner data - PopRunner is an online retailer
# Use the caselet and data (consumer.csv, pop_up.csv, purchase.csv, email.csv) 
# on D2L to answer questions below
# In this script, we will use SQL to do descriptive statistics
# Think about the managerial implications as you go along

options(warn=-1) # R function to turn off warnings
library(sqldf)

################################################################################

# Read the data in: consumer, pop_up, purchase and email tables

# set your working directory and use read.csv() to read files

setwd("C:/Usama/DePaul classes/Quarter 2 - summer 2025/MGT588 - Database managament/Assignments/Final Project") # use your path here

consumer<-read.csv("consumer.csv",header=TRUE)
pop_up<- read.csv("pop_up.csv",header=TRUE)
purchase<-read.csv("purchase.csv",header=TRUE)
email<-read.csv("email.csv",header=TRUE)

# Let us first start with exploring various tables

################################################################################

# Using SQL's LIMIT clause, display first 5 rows of all the four tables

# observe different rows and columns of the tables

################################################################################

# Query 1) Display first 5 rows of consumer table

sqldf("
      SELECT * FROM consumer LIMIT 5;
      ")

################################################################################

# Query 2) Display first 5 rows of pop_up table

sqldf("
      SELECT * FROM pop_up LIMIT 5;
      ")

################################################################################

# Query 3) Display first 5 rows of purchase table

sqldf("
      SELECT * FROM purchase LIMIT 5;
      ")

################################################################################

# Query 4) Display first 5 rows of email table

sqldf("
      SELECT * FROM email LIMIT 5;
      ")

################################################################################

# Now, let's look at the descriptive statistics one table at a time: consumer table

# Query 5: Display how many consumers are female and male (column alias: gender_count), 
#          also show what is the average age (column alias: average_age) of consumers by gender

# SELECT COUNT(*) AS <new column name>,
#        AVG(<column name>) AS <new column name>,
#        <grouping variable 1> FROM <table name> 
# GROUP BY <grouping variable 1>

# Hint: you will GROUP BY gender

sqldf("
      SELECT COUNT(*) AS 'gender_count', AVG(age) AS 'average_age', gender
      FROM consumer
      GROUP BY gender;
      ")

# Interpret your output in simple English (1-2 lines):
#The dataset contains 6,903 female consumers with an average age of about 
#30.6 years, and 2,129 male consumers with an average age of about 32.5 years.

################################################################################

# Query 6: How many consumers are there in each loyalty status group (column alias: loyalty_count), 
# what is the average age (column alias: average_age) of consumers in each group

# Syntax: 

# SELECT COUNT(*) AS <new column name>,
#        AVG(<column name>) AS <new column name>,
#        <grouping variable 1> FROM <table name> 
# GROUP BY <grouping variable 1>

# Hint: you will GROUP BY loyalty_status

sqldf("
      SELECT COUNT(*) AS loyalty_count, AVG(age) AS average_age, loyalty_status
      FROM consumer
            WHERE gender='Male'

      GROUP BY loyalty_status
      ")

# Interpret your output in simple English (1-2 lines):
# This query will show how many consumers belong to each loyalty tier 
# and what their average age is within each tier.

################################################################################

# Next, let's look at the pop_up table

# Query 7: How many consumers (column alias: consumer_count) who received a
# pop_up message (column alias: pop_up)
# continue adding discount code to their card (column alias: discount_code) 
# opposed to consumers who do not receive a pop_up message

# Syntax: 

# SELECT COUNT(*) AS <new column name>,
#        <grouping variable 1> AS <new column name>, 
#        <grouping variable 2> AS <new column name> FROM <table name> 
# GROUP BY <grouping variable 1>, <grouping variable 2>

# Hint: you will use two grouping variable: GROUP BY pop_up, saved_discount

sqldf("
      SELECT COUNT(*) AS consumer_count, pop_up AS pop_up, saved_discount AS discount_code
      FROM pop_up
      GROUP BY pop_up, saved_discount;
      ")

# Interpret your output in simple English (1-2 lines):
#This query shows that most consumers did not receive a pop up message or a discount code
#Of those who did receive a pop-up message, around 3029 chose not to save the discount 
#compared to the 1487 who did use the discount code.

################################################################################

# This is purchase table

# Query 8: On an average, how much did consumers spend on their 
# total sales (column alias: total_sales) during their online purchase

# Syntax:

# SELECT AVG(<column name>) AS <new column name> FROM <table name>

sqldf("
      SELECT AVG(sales_amount_total) AS total_sales
      FROM purchase;
      ")

# Interpret your output in simple English (1-2 lines):
#The output shows us that the average sales amount for consumers is $135.21.

################################################################################

# Finally, let's look at the email table

# Query 9: How many consumers (column alias: consumer_count) of the total opened the email blast

# Syntax:

# SELECT COUNT(*) AS <new column name>,
#       <group variable 1> from <table name> 
#   GROUP BY <group variable 1>


sqldf("
      SELECT COUNT(*) as consumer_count, opened_email
      FROM email
      GROUP BY opened_email;
      ")

# Interpret your output in simple English (1-2 lines):
#The output shows us that we can see how many consumers opened the email blast (716)
# and how many consumers did not open the email blast (8316).

######################################################################################################

# Now we will combine/ merge tables to find answers

# Query 10: Was the pop-up advertisement successful? Mention yes/ no. 
# In other words, did consumers who received a pop_up message buy more

# Syntax:

# SELECT SUM(<column name>) AS <new column name>,
#        AVG(<column name>) AS <new column name>, 
#        <grouping variable 1> from <table 1>, <table 2>
#      WHERE <table 1>.<key column>=<table 2>.<key column> 
#      GROUP BY <grouping variable 1>

# Hint: you will calculate SUM of sales_amount_total (column alias: sum_sales)
# and AVG of sales_amount_total (column alias: avg_sales)
# GROUP BY pop_up
# Inner join on purchase and pop_up table on consumer_id

sqldf("
      SELECT SUM(sales_amount_total) AS sum_sales, AVG(sales_amount_total) AS avg_sales,
      pop_up
      FROM purchase, pop_up
      WHERE purchase.consumer_id = pop_up.consumer_id
      GROUP BY pop_up;
      ")

# Interpret your output in simple English (1-2 lines):
# Based on the output, the pop up message was not successful.
# We can see that those that did not receive it had avg sales of $138.69
# and those that did had avg sales of $131.74
######################################################################################################

# Query 11) Did the consumer who spend the least during online shopping opened the pop_up message? Use nested queries.

# Write two separate queries 

# Query 11.1) Find the consumer_id who spent the least from the purchase table

# you can use ORDER BY and LIMIT clause together

# Syntax: 

# SELECT <column name> FROM <table name>
# ORDER BY <column name> LIMIT 1)

# Note: Here I am expecting details of only one consumer with minimum purchase. 
# Therefore, LIMIT 1. There are many consumers with sales_amount_total = 0, 
# however, you need information of any one for your second part of the project.

sqldf("
      SELECT consumer_id
      FROM purchase
      ORDER BY sales_amount_total
      LIMIT 1;
      ")

# Query 11.2) Use the consumer_id from the previous SELECT query to find if the consumer received a pop_up message from the pop_up table

sqldf("
      SELECT consumer_id, pop_up
      FROM pop_up
      WHERE consumer_id = 5887286353;
      ")

# Query 11.3) Using ? for inner query, create a template to write nested query

sqldf("
      SELECT consumer_id, pop_up
      FROM pop_up
      WHERE consumer_id = (?);
      ")

# Query 11.4) Replace ? with the inner query

# Syntax:

# SELECT <column name 1>, <column name 2> FROM <table name> WHERE consumer_id = 
#      (inner query from Query 11.1)


sqldf("
      SELECT consumer_id, pop_up
      FROM pop_up
      WHERE consumer_id = (SELECT consumer_id
      FROM purchase
      ORDER BY sales_amount_total
      LIMIT 1);
      ")

# Interpret your output in simple English (1-2 lines):
# Based on the output we can see that the least spending consumer did not receive
# the pop up message.

######################################################################################################

# Query 12: Was the email blast successful? Mention yes/ no. 
# In other words, did consumers who opened the email blast buy more

# Syntax:

# SELECT SUM(<column name>) AS <new column name>,
#        AVG(<column name>) AS <new column name>, 
#        <grouping variable 1> from <table 1>, <table 2>
#      WHERE <table 1>.<key column>=<table 2>.<key column> 
#      GROUP BY <grouping variable 1>

# Hint: you will calculate SUM of sales_amount_total (column alias: sum_sales) 
# and AVG of sales_amount_total (column alias: avg_sales)
# GROUP BY opened_email
# Inner join on purchase and email table on consumer_id

sqldf("
      SELECT SUM(sales_amount_total) AS sum_sales, 
      AVG(sales_amount_total) AS avg_sales,
      opened_email
      FROM purchase, email
      WHERE purchase.consumer_id = email.consumer_id
      GROUP BY opened_email;
      ")

# Interpret your output in simple English (1-2 lines):
# Based on the output we can see that the email blast was successful, as the 
# average spending was $240 for those that opened and $126 for those that didnt.

######################################################################################################

# Query 13) Did the consumer who spend the most during online shopping opened 
#           the email message? Use nested queries.

# Write two separate queries 

# Query 13.1) Find the consumer_id who spent the most from the purchase table

# you can use ORDER BY and LIMIT clause together

# Syntax: 

# SELECT <column name> FROM <table name>
# ORDER BY <column name> DESC LIMIT 1)

sqldf("
      SELECT consumer_id FROM purchase
      ORDER BY sales_amount_total DESC
      LIMIT 1;
      ")

# Query 13.2) Use the consumer_id from the previous SELECT query to find if 
#             the consumer opened the email from the email table

sqldf("
      SELECT opened_email
      FROM email
      WHERE consumer_id = 5955534353;
      ")

# Query 13.3) Using ? for inner query, create a template to write nested query

sqldf("
      SELECT opened_email, consumer_id
      FROM email
      WHERE consumer_id = (?);
      ")

# Query 13.4) Replace ? with the inner query

# Syntax:

# SELECT <column name 1>, <column name 2> FROM <table name> WHERE consumer_id IN 
#      (inner query from Query 11.1)


sqldf("
      SELECT opened_email, consumer_id
      FROM email
      WHERE consumer_id = (SELECT consumer_id FROM purchase
      ORDER BY sales_amount_total DESC
      LIMIT 1);
      ")

# Interpret your output in simple English (1-2 lines):
# The consumer that spent the most during online shopping did open the email blast.

######################################################################################################
# Best Luck!
######################################################################################################

