if (navigator.serviceWorker) {
  navigator.serviceWorker.register('/serviceworker.js', { scope: './' })
    .then(function(reg) {
      console.log('[Companion]', 'Service worker registered!');

      // If notification allowed
      reg.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: window.vapidPublicKey,
      }).then(subscribeSuccess);
    });
}

// 参考: (https://www.lanches.co.jp/blog/6723)
var subscribeSuccess = function(subscription){
  params = {
    subscription: subscription.toJSON();
  }
  
  $.ajax({
    type: 'POST',
    url: '/devices',
    data: params
  });
}
