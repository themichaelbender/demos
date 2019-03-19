#This is a new script
get-service | Where-Object Status -EQ 'stopped'