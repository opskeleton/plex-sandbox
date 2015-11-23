node default {
  Service {
    provider => 'systemd'
  }
  include plexmediaserver
}
