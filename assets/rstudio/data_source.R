library(projectLib)
project <- projectLib::Project$new()

# To Do: change or verify connection name. It should match the connection name that you defined in your project
DB2_Cloud_metadata = project$get_connection(name="DB2onCloud")

library(RJDBC)

drv <- JDBC(driverClass="com.ibm.db2.jcc.DB2Driver", classPath="/opt/jdbc/db2jcc4.jar", identifier.quote = "\"")

DB2_Cloud_url <- paste("jdbc:db2://",
                        DB2_Cloud_metadata[][["host"]],
                        ":", "50000",
                        "/", DB2_Cloud_metadata[][["database"]],
                        sep=""
)

DB2_Cloud_connection <- dbConnect(drv,
                                  DB2_Cloud_url,
                                  DB2_Cloud_metadata[][["username"]],
                                  DB2_Cloud_metadata[][["password"]]
)

# To Do: change to your own table
query <- "SELECT * FROM JPF66625.CREDITDATA"

data <- dbSendQuery(DB2_Cloud_connection, query)
# fetch first 5 rows
data_df_1 <- dbFetch(data, n = 5)
head(data_df_1)

#save iris to database
library(nnet)

dbWriteTable(DB2_Cloud_connection, "JPF66625.IRISTBL", iris)
