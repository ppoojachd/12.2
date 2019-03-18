### Merge Data Frames
merge(x, y, by.x = by, by.y = by, all = FALSE, all.x = all, all.y = all...)

## Data Creation
Personnal <- data.frame(ID=c(10001,10002,10003,10005,10006),
                       Name = c("Mohit","Pratap","Srini","Pavan","Vinay"), Age = c(25,30,27,25,27),
                       DOB=c("26-06-1992","2-10-1987","26-11-1990","21-012-1992","20-2-1990"))

Professional <- data.frame(ID=c(10003,10005,10006,10008), 
                        Salary = c(1600000,1500000,1400000,1230000),
                        Designation=c("BA","SE","DS","BA"))

## Inner Join
merge(Personnal,Professional,by.x = "ID",by.y ="ID")

## Left Join
merge(Personnal,Professional,by.x = "ID",by.y ="ID",all.x = TRUE)

## Right Join
merge(Personnal,Professional,by.x = "ID",by.y ="ID",all.y = TRUE)

## Full Outer join
merge(Personnal,Professional,by.x = "ID",by.y ="ID",all = TRUE)


### dplyr package
library(ggplot2)
library(dplyr)
#data<-read.csv("https://sites.google.com/site/pocketecoworld/sampledata.csv")
diamond<-diamonds

# Select N rows randomly
sample_n(diamond,10)

## Distinct()
# delete duplicate rows
distinct(diamond)

# Remove duplicates based on variable
d<-distinct(diamond, cut, .keep_all= TRUE)

# Remove duplicates based on multiple variable
d<-distinct(diamond, cut, depth, .keep_all= TRUE)

## select()
# select variables
select(diamond, cut)
# select multiple variables
select(diamond, carat, price:z)
# dropping variables
select(diamond, -cut, -c(x:z))
# select/drop variables starts with c
select(diamond, starts_with("c"))
select(diamond, -starts_with("c"))

## rename()
rename(diamond, qualityCut = cut)

## filter = filter(data, condition)
filter(diamond, color == "E")
filter(diamond, color %in% c("E","H"))

## summarise() : to find descriptive stats
summarise(diamond, max(price),min(price),mean(depth))
# summarise all numeric variables
summarise_if(diamond, is.numeric, funs(n(),mean,median))

## arrange()
arrange(diamond, price)
arrange(diamond, desc(price))
arrange(diamond, desc(price),z)

## group_by()
group_by(diamond, cut) %>% summarise(mean(price))
group_by(diamond, cut) %>% summarise(median(depth))
group_by(diamond, color) %>% summarise(mean(price))


## %>% operator
diamond %>% select(color, price, cut) 

diamond %>% select(color, price, cut) %>% 
  filter(color == "E" & cut == "Ideal") 

diamond %>% select(color, price, cut) %>% 
  filter(color == "E" & cut == "Ideal") %>% 
  arrange(desc(price)) 

## Join functions in dplyr
## Data Creation
Personnal <- data.frame(ID=c(10001,10002,10003,10005,10006),
                        Name = c("Mohit","Pratap","Srini","Pavan","Vinay"), Age = c(25,30,27,25,27),
                        DOB=c("26-06-1992","2-10-1987","26-11-1990","21-012-1992","20-2-1990"))

Professional <- data.frame(ID1=c(10003,10005,10006,10008), 
                           Salary = c(1600000,1500000,1400000,1230000),
                           Designation=c("BA","SE","DS","BA"))

## joins
# Inner Join
inner_join(Personnal, Professional, by = c("ID"="ID1"))
# Left joins
left_join(Personnal, Professional, by = c("ID"="ID1"))
# Right joins
right_join(Personnal, Professional, by = c("ID"="ID1"))
#Full joins
full_join(Personnal, Professional, by = c("ID"="ID1"))

# intersect(), union, and setdiff
library(ggplot2)
diamond = diamonds
df1<-distinct(diamond[1:10000,])
df2<-distinct(diamond[9951:11000,])
# intersect
nrow(intersect(df1, df2))
# union
nrow(union(df1, df2))
# setdiff()
nrow(setdiff(df1, df2))
nrow(distinct(df1))

###################################### Reshaping data using tidyr package ##########
install.packages("tidyr")
library(tidyr)

## create dataframe
set.seed(1234)
tidyr.ex<-data.frame(
  participant = c("p1","p2","p3","p4","p5","p6"),
  info = c("g1m","g1m","g1f","g2m","g2m","g2m"),
  day1score = rnorm(n=6, mean=80, sd = 15),
  day2score = rnorm(n=6, mean=88, sd = 8)
)

## gather() 
tidyr.ex<-tidyr.ex %>% gather(day, score, c(day1score,day2score))

## spread
tidyr.ex %>% spread(day, score)

## separate()
tidyr.ex<- tidyr.ex %>% separate(col = info, into=c("group","gender"), sep = 2)

## unite()
tidyr.ex %>% unite(info, group, gender, sep = "")

## Class Practice
# create data frame
df <- data.frame(Group=rep(1:3,each=4), year = rep(2006:2009,3)
                 ,Qtr.1=c(15,12,12,13,14,12,15,13,14,12,15,17),Qtr.2=c(11,14,22,12,14,16,15,13,14,13,12,18),
                 Qtr.3=c(18,21,13,22,14,16,25,18,16,12,21,23),
                 Qtr.4=c(25,12,22,13,23,24,15,13,14,22,15,20))

# Restructure the data frame in the long format so that the time component as a single variable (name = Quarter)
df<-df %>% gather(Quarter, Revenue, Qtr.1:Qtr.4)
# df %>% gather(Quarter, Revenue, Qtr.1:Qtr.4)
# df %>% gather(Quarter, Revenue, -Group, -Year)
# df %>% gather(Quarter, Revenue, 3:6)
# df %>% gather(Quarter, Revenue, Qtr.1, Qtr.2, Qtr.3, Qtr.4)
df %>% unite(gear,year,Quarter,sep = "_")

####################################################################################
## SQLDF Package
library("sqldf")
# Use "UCBAdmissions" data
df<-as.data.frame(UCBAdmissions)

# SOlve below problems using sqldf()
#1. How many number of rows are in the data?
sqldf("select count(*) from df")
#2. SHow only female student admission result
sqldf("select * from df where Gender = 'Female'")
#3. Return admitted students
sqldf("select * from df where Admit = 'Admitted'")
#4. how many departments are in the college?
sqldf("select distinct Dept from df")
#5. Find total admitted students
sqldf("select sum(Freq) from df where Admit = 'Admitted'")
#6. Find total accepted males and females
sqldf("select sum(Freq) from df where Admit = 'Admitted' group by Gender")
#7 Average number of admitted students by departments
sqldf("select Dept, avg(Freq) from df where Admit = 'Admitted' group by Dept")
#8. Which department had the most admitted students
sqldf("select Dept, max(Total) from (select Dept, sum(Freq) as Total from df where Admit = 'Admitted' group by Dept)")
#9. Which department had the most admitted female students
sqldf("select Gender, Dept, max(Freq) from df where Admit = 'Admitted' and Gender = 'Female'")

# Create table majors
majors <- data.frame(major = c("math", "biology", "engineering", 
                               "computer science", "history", "architecture"), 
                     Dept = c(LETTERS[1:5], "Other"), 
                     Faculty = round(runif(6, min = 10, max = 30)))

#10. How many Male students will be doing majors in "Biology"
sqldf("select d.Freq from (select Dept, Freq from df where Gender = 'Male' and Admit = 'Admitted') d join majors m on d.Dept = m.Dept where major = 'biology'")
#11. How many students will be doing majors in either math or computer science
sqldf("select sum(Total) from (select Dept, sum(Freq) as Total from df where Admit = 'Admitted' group by dept) d join majors m on d.Dept = m.Dept where major in ('computer science', 'math')")


################# Data.table Package
library(data.table)
head(mtcars)
dt <- data.table(mtcars)
head(dt)

## where/i part
head(mtcars[2:5]) # returned column
head(dt[2:5]) # returns rows

head(mtcars[hp>100,])   ## Error in data frame
head(dt[hp>100])
dt[hp>100 & wt>4]
# .N notation
dt[.N] ## will give last row
dt[.N-1] ## will give 2nd last row


## j/select part
mtcars[,mean(mtcars$mpg)]  ## Error in data frame
dt[,mean(mpg)]
dt[,mean(mpg),max(wt)]
## .() notation
dt[,.(mean(mpg), max(wt))]
dt[,.(mpgAverage = mean(mpg), WTmax = max(wt))]
#dt[,.(m = mpg)]

## by/group by clause
dt[,mean(mpg),by=gear]
dt[,max(wt),by=am]
dt[,.(max(wt),mean(mpg)),by=am]
dt[,.(WtMax=max(wt),mpgAvg=mean(mpg)),by=am]
dt[,.(PeakUpAvg = mean(qsec),dispMed = median(disp)),
   by = .(carb,cyl)]

## Other Important operators of data.table
# := operator
dt<-data.table(mtcars)
dt[10]
dt[10,carb:=5][10]
names(dt[,MileageperWt:=mpg/wt])

# Task 1: Add all categories of gear for each cyl to original data.table as a list.
dt<-data.table(mtcars)
dt[,.(g = unique(gear)),by=cyl]
head(dt[,gearsL:=.(list(unique(gear))),by=cyl])
# Task 2: Accessing elements from a column of lists
head(dt[,gearsL1:=lapply(gearsL, function(x) x[2])])
#head(dt[,gearsS1:=sapply(gearsL, function(x) x[2])])
head(dt[,gearsS2:=sapply(gearsL, '[',2)])
# Task 3:Calculate all the gears for all cars of each cyl (excluding the current current row).
head(dt[,other_gear:=mapply(function(x,y) setdiff(x,y),x=gearsL,y=gear)])
head(dt[,other_gear:=mapply(setdiff,x=gearsL,y=gear)])

## "{" operator to suppress intermediate output
dt <- data.table(mtcars)
dt[,{tmp1=mean(mpg); tmp2=mean(abs(mpg-tmp1));tmp3=round(tmp2,2)},by=cyl]
dt[,{tmp1=mean(mpg); tmp2=mean(abs(mpg-tmp1));tmp3=round(tmp2,2);list(tmp2=tmp2,tmp3=tmp3)},by=cyl]
## try to do with := operator
head(dt[,tmp1:=mean(mpg), by=cyl][,tmp2:=mean(abs(mpg-tmp1)), by=cyl][,tmp1:=NULL])

#using shift for to lead/lag vectors and lists
dt <- data.table(mtcars)[,.(mpg,cyl)]
head(dt[,mpg_lag1:=shift(mpg,1)])
head(dt[,mpg_forward:=shift(mpg,1, type='lead')])

#create multiple columns using := in one statement
dt <- data.table(mtcars)[,.(mpg,cyl)]
head(dt[,':=' (ave = mean(mpg),med = median(mpg), 
               min = min(mpg), 
               max = max(mpg)),
        by = cyl])

############## stringr Package #########################
library(stringr)
x <- c("abcdef", "ghifjk")
str_length(x)
str_sub(x, 3, 3)
str_sub(x, 3, 3) <- "X"

## whitespace
x <- c("abc", "defghi")
str_pad(x, 10) # default pads on left
str_pad(x, 10, "both")
x <- c("  a   ", "b   ",  "   c")
str_trim(x)
str_trim(x, "left")

## Sensitive
x <- "Data Science is the future"
str_to_upper(x)
str_to_title(x)
str_to_lower(x)

x <- c("y", "i", "k")
str_order(x)
str_sort(x)

### Lubridate Package
library(lubridate)
today()
year(today())
month(today())
day(today())
