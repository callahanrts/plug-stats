For Architecture help
- https://github.com/krisajenkins/beeline-demo/blob/master/src/State.elm
- There's another link somewhere by this guy
  - http://blog.jenkster.com/2016/04/how-i-structure-elm-apps.html


Get Playlists

GET `/_/playlists`

Add to Playlist

POST `/_/playlists/{{pid}}/media/insert`
  {
    media: {{media object}}
    append: true
  }
