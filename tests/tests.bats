@test "Logging in to Drupal" {
  run curl --request POST --header "Content-type: application/json" --data '{ "username":"admin", "password":"'${ADMINPASS'"}' --cookie cookies.txt http://localhost/drupal/user/login
  [ "${status}" -eq 0 ]
}
