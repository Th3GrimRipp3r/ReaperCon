on ^*:SNOTICE:*: {
  if (used SVSNICK to change Peer to isincs $1-) {
    nick $ajoin(nickname)
    .timer 1 1 notice $gettok($7,1,33) Nice try.. Shame it failed.. :P
  }
}
