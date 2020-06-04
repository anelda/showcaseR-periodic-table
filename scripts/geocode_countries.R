geocode_countries <- function(in_data, address) {
  
  unique_addresses <- unique(in_data[address])

  
  # Create empty dataframe to capture addresses
  geocode_df <- data.frame()

  # Run through healthsites_tb one entry at a time to allow system pause between making
  # calls to open street maps as per their fair usage policy

  for (i in 1:dim(unique_addresses)[1]) {

    print(paste("Row number: ", i))
    print(paste("Unique address: ", unique_addresses[i,]))

    temp_df <- geocode_OSM(as.character(unique_addresses[i,]), as.data.frame = TRUE)

    geocode_df <- geocode_df %>%
      bind_rows(temp_df)

    # Not allowed to make more than 1 call per second, so we'll make 1 call per 10 seconds
    print('Sleeping for 10 seconds')
    Sys.sleep(10)

  }

  # Drop extra columns
  geocode_df <- geocode_df %>%
  select(c(query, lat, lon))

  return(geocode_df)
}



