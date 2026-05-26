// OpenRailRouting configuration
window.routingConfig = {
  apiUrl: window.location.origin,
  defaultProfile: 'tgv_all',
  profiles: [
    { name: 'tgv_all', label: 'TGV (All)' },
    { name: 'non_tgv', label: 'Non-TGV' },
    { name: 'tramtrain', label: 'Tram/Train' },
    { name: 'all_tracks', label: 'All Tracks' },
    { name: 'all_tracks_1435', label: 'All Tracks (1435mm)' }
  ]
};

