################################################################################
# Lec02.R
# 04/15/2022
################################################################################
rm(list = ls()) # all clear

################################################################################
# Reset Graphics
################################################################################
old.par <- par(no.readonly = TRUE)

################################################################################
# Load Libraries
################################################################################
library(tidyverse)
library(readxl)

################################################################################
# Load Functions
################################################################################

################################################################################
# Define Functions
################################################################################

################################################################################
# Set Parameters
################################################################################


################################################################################
# Rの使い方と基礎概念
################################################################################
# "#"から後はコメントになり、プログラムの実行上無視される。

#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=
# 電卓として使う
#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=
45 + 57
33 / 25
(sin(0.5)) ^ 2 + (cos(0.5)) ^ 2

#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=
# ベクトル
#　注意: Rの変数名は大文字と小文字を区別します！
#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=

# - - - - - [c関数] ベクトルを作る関数
x <- c(0, 2, 5, 8)

#------------------------------------------------------------------------------#
# 添字による要素の取り出し
#------------------------------------------------------------------------------#
x[2]
x[c(2, 4)]

# 負の数はそれ以外を取りだす
x[-2]

#------------------------------------------------------------------------------#
# 論理変数による要素の取り出し
#------------------------------------------------------------------------------#
x[c(TRUE, FALSE, F, T)]     # TRUE, FALSEを推奨

# これにより条件式による取り出しが可能
x > 3
x[x > 3]

#------------------------------------------------------------------------------#
# 名前（属性）と名前による要素の取り出し
#------------------------------------------------------------------------------#
# - - - - - [names関数] 名前属性の表示・設定
names(x) <- c("Spring", "Summer", "Fall", "Winter")
x

x["Summer"]             # 名前による要素の取り出し

#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=
# 行列と配列
#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=
#------------------------------------------------------------------------------#
# 行列
#------------------------------------------------------------------------------#
# - - - - - [seq関数] 数列を作る。変数は(始点、終点、間隔)
M0 <- seq(0.1, 2.4, 0.1)

# - - - - - [matrix関数] 行列を生成
M1 <- matrix(M0, nrow = 6)

# - - - - - [paste0関数] 文字列を結合
paste0("R", seq(6))    

# - - - - - [list関数] リストを作成
# - - - - - [dimnames関数] 行列の行と列に名前をつける・表示する
dimnames(M1) <- list(paste0("R", seq(6)), paste0("C", seq(4)))
M1

#------------------------------------------------------------------------------#
# 配列
#------------------------------------------------------------------------------#
# - - - - - [array関数] 配列を生成
M2 <- array(M0, dim = c(2, 2, 3))   
dimnames(M2) <- list(paste0("A_", seq(2)), 
                     paste0("B_", seq(2)),
                     paste0("C_", seq(3)))

#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=
# データフレーム
#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=
AgeData <- c(35, 42, 58, 25, 44)
CountryData <- c("JPN", "USA", "USA", "JPN", "JPN")
IncomeData <- c(40, 35, 52, 26, 32)

# - - - - - [data.frame関数] データフレームを生成
SurveyData <- data.frame(Age = AgeData, Country = CountryData, Income = IncomeData, 
                         stringsAsFactors = FALSE)
SurveyData$Income
SurveyData[2, 1]

SurveyData$Country[2] <- "FRA"

SurveyData

################################################################################
# 人口動態調査の2020年全死因・男性の年齢調整死亡率を計算
################################################################################
VS_Dir <- "VS/"

#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=
# 死亡数読み込み
#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=
# - - - - - [read_excel関数] Excelファイルを読み込む
D00_raw <- read_excel(path = paste0(VS_Dir, "mc150000.xlsx"), 
                      sheet = 1, skip = 7, col_names = TRUE, col_types = "numeric")
D00M <- c(D00_raw$`2020`[seq(26, 44)], sum(D00_raw$`2020`[seq(45, 46)]))

#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=
# 人口読み込み
#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=
# - - - - - [read_csv関数] CSVファイルを読み込む
PopM_raw <- read_csv(file = paste0(VS_Dir, "mi030002.csv"),
                     skip = 11, col_names = TRUE, col_types = list(.default = "n"))
PopM <- c(PopM_raw$`2020`[seq(7, 25)], sum(PopM_raw$`2020`[seq(26, 27)]))

Mx00M <- D00M / PopM

#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=
# 平成27年モデル人口読み込み
#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=
ModelPop_raw <- read_excel(path = paste0(VS_Dir, "kijunjinkou(h27).xlsx"), 
                           sheet = 1, skip = 5, col_names = FALSE, col_types = "numeric")
ModelPop <- c(sum(ModelPop_raw[seq(2), 2]), unlist(ModelPop_raw[-seq(2), 2]))

Cx_ModelPop <- ModelPop / sum(ModelPop)

sum(Mx00M * Cx_ModelPop) * 100000

################################################################################
# 2020年悪性新生物・男性の年齢調整死亡率は？
################################################################################


