install.packages("utf8")
library(dplyr)
library(caret)
library(ggplot2)

ds <- read.csv("E:/9th semester-Summer 2025/Data Science/Project1/Midterm_Dataset_Section(E).csv",na = c("NA", ""),stringsAsFactors = FALSE, fileEncoding = "UTF-8")
head(ds)
summary(ds)
str(ds)


colSums(is.na(ds))


ds_delete <- na.omit(ds)
colSums(is.na(ds_delete))
head(ds_delete, 20) 


for (col in names(ds)) {
  if (is.numeric(ds[[col]])) {
    mean_val <- mean(ds[[col]], na.rm = TRUE)  
    ds[[col]][is.na(ds[[col]])] <- mean_val
  }
}
colSums(is.na(ds))


for (col in names(ds)) {
  if (is.character(ds[[col]]) || is.factor(ds[[col]])) 
  {
    mode_val <- names(which.max(table(ds[[col]])))
    ds[[col]][is.na(ds[[col]])] <- mode_val
  }
}
colSums(is.na(ds))



missing_counts <- colSums(is.na(ds))

barplot(missing_counts,
        main = "Missing Values per Column",
        xlab = "Columns",
        ylab = "Number of Missing Values",
        col = "skyblue",
        las = 2) 


detect_outliers <- function(x) {
  Q1 <- quantile(x, 0.25, na.rm = TRUE)
  Q3 <- quantile(x, 0.75, na.rm = TRUE)
  IQR_val <- Q3 - Q1
  lower_bound <- Q1 - 1.5 * IQR_val
  upper_bound <- Q3 + 1.5 * IQR_val
  return(x < lower_bound | x > upper_bound)
}

numeric_column <- names(ds)[sapply(ds, is.numeric)]
for(col in numeric_column) {
  outlier <- detect_outliers(ds[[col]])
  cat("Column:", col, "- Outliers found:", sum(outlier, na.rm = TRUE), "\n")
}



ds_outlier_delete <- ds

for(col in numeric_column) {
  outlier <- detect_outliers(ds_outlier_delete[[col]])
  ds_outlier_delete <- ds_outlier_delete[!outlier, ]
}

numeric_column <- names(ds_outlier_delete)[sapply(ds_outlier_delete, is.numeric)]
for(col in numeric_column) {
  outlier <- detect_outliers(ds_outlier_delete[[col]])
  cat("Column:", col, "- Outliers found:", sum(outlier, na.rm = TRUE), "\n")
}


ds_outlier_mean <- ds

for(col in numeric_column) {
  outlier <- detect_outliers(ds_outlier_mean[[col]])
  mean_val <- mean(ds_outlier_mean[[col]], na.rm = TRUE)
  ds_outlier_mean[[col]][outlier] <- mean_val
}

for(col in numeric_column) {
  outlier <- detect_outliers(ds_outlier_mean[[col]])
  cat("Column:", col, "- Outliers found:", sum(outlier, na.rm = TRUE), "\n")
}


for(col in numeric_column) {
  outlier <- detect_outliers(ds[[col]])
  median_val <- median(ds[[col]], na.rm = TRUE)
  ds[[col]][outlier] <- median_val
}

for(col in numeric_column) {
  outlier <- detect_outliers(ds[[col]])
  cat("Column:", col, "- Outliers found:", sum(outlier, na.rm = TRUE), "\n")
}



valid_values <- list(
  Gender = c("Male", "Female"),
  Have.you.ever.had.suicidal.thoughts.. = c("Yes", "No"),
  Depression = c("Yes", "No"),
  Family.History.of.Mental.Illness = c("Yes", "No"),
  Dietary.Habits = c("Moderate", "Healthy", "Unhealthy"),
  Sleep.Duration = c("7-8 hours", "5-6 hours", "More than 8 hours", "Less than 5 hours")
)

count_invalid <- function(row) {
  sum(sapply(names(valid_values), function(col) {
    !(row[[col]] %in% valid_values[[col]])
  }))
}

ds$Invalid_Count <- apply(ds, 1, count_invalid)

invalid_rows <- ds[dm$Invalid_Count > 0, ]
invalid_rows


ds$Gender<-ifelse(ds$Gender %in% c("Feemale","Female"),"Female",
                  ifelse(ds$Gender %in% c("Maleee","Male"),"Male",ds$Gender))


ds$Gender<-factor(ds$Gender,levels = c("Male","Female"),labels=c(1,0))
ds$Depression<-factor(ds$Depression,levels = c("Yes","No"),labels=c(1,0))
ds$Have.you.ever.had.suicidal.thoughts..<-factor(ds$Have.you.ever.had.suicidal.thoughts..,levels = c("Yes","No"),labels=c(1,0))
ds$Family.History.of.Mental.Illness<-factor(ds$Family.History.of.Mental.Illness,levels = c("Yes","No"),labels=c(1,0))
ds$Dietary.Habits<-factor(ds$Dietary.Habits,levels = c("Moderate","Healthy","Unhealthy"),labels=c(0.5,1,0))
ds$Sleep.Duration<-factor(ds$Sleep.Duration,levels = c("7-8 hours","5-6 hours","More than 8 hours","Less than 5 hours"),labels=c(0.75,0.25,1,0))

head(ds, 10)




normalize <- function(x) {
  return((x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE)))
}

ds[numeric_column] <- lapply(ds[numeric_column], normalize)
head(ds, 10)

duplicates <- duplicated(dm)
sum(duplicates) 

ds <- ds[!duplicates, ]
sum(duplicated(ds))

ds_filtered <- ds[ds$Gender == 1 & ds$Depression == 1, ]
head(ds_filtered, 5)


ds_filtered <- ds %>% filter(Age > 0.5, Gender == 1)
head(ds_filtered, 5)

ds_filtered <- subset(ds, Age > 0.5 & Dietary.Habits == 1)
head(ds_filtered, 5)



cat_cols <- names(ds)[sapply(dm, function(x) is.factor(x) || is.character(x))]

for (col in cat_cols) {
  counts <- table(ds[[col]]) 
  ratio <- ifelse(length(counts) > 1, max(counts)/min(counts), NA)
  cat("Column:", col, "\n")
  print(counts)
  cat("Imbalance ratio (max/min):", round(ratio,2), "\n)
}


minority <- ds %>% filter(Depression == 1)
majority <- ds %>% filter(Depression == 0)

set.seed(123)
minority_oversampled <- minority %>%
  sample_n(size = nrow(majority), replace = TRUE)
ds_balanced <- bind_rows(majority, minority_oversampled)
ds_balanced <- ds_balanced[sample(nrow(ds_balanced)), ]
table(ds_balanced$Depression)
dim(ds_balanced)



set.seed(123)

index <- createDataPartition(ds_balanced$Depression, p = 0.8, list = FALSE)

train_data <- ds_balanced[index, ]
test_data  <- ds_balanced[-index, ]

cat("Training Data Rows:", nrow(train_data), "\n")
cat("Testing Data Rows:", nrow(test_data), "\n")



install.packages("utf8")
library(dplyr)

study_stats <- ds_balanced %>%
  group_by(Depression) %>%
  summarise(
    Count = n(),
    Mean = mean(Study.Hours, na.rm = TRUE),
    Median = median(Study.Hours, na.rm = TRUE),
    SD = sd(Study.Hours, na.rm = TRUE),
    Min = min(Study.Hours, na.rm = TRUE),
    Max = max(Study.Hours, na.rm = TRUE),
    Q1 = quantile(Study.Hours, 0.25, na.rm = TRUE),
    Q3 = quantile(Study.Hours, 0.75, na.rm = TRUE)
  )


age_stats <- ds_balanced %>%
  group_by(Depression) %>%
  summarise(
    Count = n(),
    Mean = mean(Age, na.rm = TRUE),
    Median = median(Age, na.rm = TRUE),
    SD = sd(Age, na.rm = TRUE),
    Min = min(Age, na.rm = TRUE),
    Max = max(Age, na.rm = TRUE),
    Q1 = quantile(Age, 0.25, na.rm = TRUE),
    Q3 = quantile(Age, 0.75, na.rm = TRUE)
  )


study_stats
age_stats

library(dplyr)


sleep_stats <- ds_balanced %>%
  group_by(Depression) %>%
  summarise(
    Count = n(),
    Mean_Sleep = mean(as.numeric(Sleep.Duration), na.rm = TRUE),
    Median_Sleep = median(as.numeric(Sleep.Duration), na.rm = TRUE),
    SD_Sleep = sd(as.numeric(Sleep.Duration), na.rm = TRUE),
    Min_Sleep = min(as.numeric(Sleep.Duration), na.rm = TRUE),
    Max_Sleep = max(as.numeric(Sleep.Duration), na.rm = TRUE),
    Q1_Sleep = quantile(as.numeric(Sleep.Duration), 0.25, na.rm = TRUE),
    Q3_Sleep = quantile(as.numeric(Sleep.Duration), 0.75, na.rm = TRUE)
  )

sleep_stats



library(dplyr)

study_spread <- ds_balanced %>%
  group_by(Study.Satisfaction) %>%
  summarise(
    Count = n(),
    Mean_Study_Hours = mean(Study.Hours, na.rm = TRUE),
    Median_Study_Hours = median(Study.Hours, na.rm = TRUE),
    SD_Study_Hours = sd(Study.Hours, na.rm = TRUE),
    Min_Study_Hours = min(Study.Hours, na.rm = TRUE),
    Max_Study_Hours = max(Study.Hours, na.rm = TRUE),
    Q1_Study_Hours = quantile(Study.Hours, 0.25, na.rm = TRUE),
    Q3_Study_Hours = quantile(Study.Hours, 0.75, na.rm = TRUE)
  )

study_spread

library(ggplot2)
ggplot(ds_filtered, aes(x = Study.Hours, fill = Study.Satisfaction)) +
  geom_histogram(bins = 20, color = "black", alpha = 0.7) +
  facet_wrap(~Study.Satisfaction) +
  labs(title = "Study Hours Distribution by Study Satisfaction Level",
       x = "Normalized Study Hours",
       y = "Count") +
  theme_minimal()

head(ds,20)
  write.csv(ds, "E:/9th semester-Summer 2025/Data Science/Project1/Midterm_Dataset_Section(E).csv", row.names = FALSE)

