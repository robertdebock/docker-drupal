@test "Opening Drupal." {
  run curl http://localhost/drupal/
  [ "${status}" -eq 0 ]
}

@test "Logging in to Drupal." {
  run curl --request POST --header "Content-type: application/json" --data '{ "username":"admin", "password":"newpass"}' --cookie-jar cookies.txt http://localhost/drupal/user/login
  [ "${status}" -eq 0 ]
}

@test "Checking status report." {
  run curl --request POST --header "Content-type: application/json" --cookie cookies.txt http://localhost/drupal/admin/reports/status | grep system-status-report__entry system-status-report__entry--error
  [ "${status}" -ne 0 ]
}

@test "Logging out of Drupal." {
  run curl --request POST --header "Content-type: application/json" --cookie-jar cookies.txt http://localhost/drupal/user/logout
  [ "${status}" -eq 0 ]
}

@test "Searching for content." {
  run curl --request GET http://localhost/drupal/search/node?keys=content
  [ "${status}" -eq 0 ]
}

@test "False logging in to Drupal." {
  run curl --request POST --header "Content-type: application/json" --data '{ "username":"admin", "password":"incorrectpass"}' https://localhost/drupal/user/login
  [ "${status}" -ne 0 ]
}
