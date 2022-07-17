while true
do
  terraform apply -auto-approve
  status=$?
  if test $status -eq 0
  then
    echo "Success"
    exit 0
  else
    echo "failed with error code $status"
    sleep 30
  fi
done
