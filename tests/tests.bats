@test "Opening Drupal." {
  run curl http://localhost/drupal/
  [ "${status}" -eq 0 ]
}

@test "Logging in to Drupal." {
  run curl http://localhost/drupal/user/login --cookie-jar cookie.txt -F 'name=admin' -F 'pass=newpass' -F 'form_id=user_login_form' -F 'op=Log+in'
  [ "${status}" -eq 0 ]
}

@test "Checking status report." {
  run curl http://localhost/drupal/user/1 --cookie cookies.txt | grep -- 'system-status-report__entry system-status-report__entry--error'
  [ "${status}" -ne 0 ]
}

@test "Logging out of Drupal." {
  run curl --cookie-jar cookies.txt http://localhost/drupal/user/logout
  [ "${status}" -eq 0 ]
}

@test "Searching for content." {
  run curl http://localhost/drupal/search/node?keys=content
  [ "${status}" -eq 0 ]
}

@test "False logging in to Drupal." {
  run curl http://localhost/drupal/user/login --cookie-jar cookie.txt -F 'name=admin' -F 'pass=incorrectpass' -F 'form_id=user_login_form' -F 'op=Log+in'
  [ "${status}" -ne 0 ]
}
