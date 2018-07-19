if (navigator.serviceWorker) {
  navigator.serviceWorker.register('/serviceworker.js', { scope: './' })
    .then(function(reg) {
      console.log('[Companion]', 'Service worker registered!');
    }).catch(function(err) {
      // 登録失敗 :(
      console.log('ServiceWorker registration failed (but companion is called): ', err);
    });
}
