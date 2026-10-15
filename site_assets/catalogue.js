document.addEventListener("DOMContentLoaded", function () {
  var tabs = document.querySelectorAll('#area-tabs [data-bs-toggle="pill"]');
  tabs.forEach(function (tab) {
    if (tab.dataset.bsTarget === location.hash) {
      bootstrap.Tab.getOrCreateInstance(tab).show();
    }
    tab.addEventListener("shown.bs.tab", function () {
      history.replaceState(null, "", tab.dataset.bsTarget);
    });
  });
});
