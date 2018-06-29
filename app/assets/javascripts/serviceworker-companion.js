if (navigator.serviceWorker) {
  navigator.serviceWorker.register('/assets/serviceworker.js'/*, { scope: './' }*/)
    .then(function(reg) {
      console.log('[Companion]', 'Service worker registered!');
    }).catch(function(err) {
      // 登録失敗 :(
      console.log('ServiceWorker registration failed: ', err);
    });
}
