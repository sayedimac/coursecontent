document.addEventListener("DOMContentLoaded", function () {
  var tabs = document.querySelectorAll('#area-tabs [data-bs-toggle="pill"]');
  var courses = document.querySelectorAll(".course-list .accordion-collapse");

  function courseFromHash() {
    var name = location.hash.slice(1);
    return Array.from(courses).find(function (course) {
      return course.id === "course-" + name || course.id === name;
    });
  }

  function showFromHash() {
    var course = courseFromHash();
    var target = course ? "#" + course.closest(".tab-pane").id : location.hash;
    tabs.forEach(function (tab) {
      if (tab.dataset.bsTarget === target) {
        bootstrap.Tab.getOrCreateInstance(tab).show();
      }
    });
    if (course) {
      if (course.classList.contains("show")) {
        course.scrollIntoView({ block: "nearest" });
      } else {
        course.addEventListener("shown.bs.collapse", function () {
          course.scrollIntoView({ block: "nearest" });
        }, { once: true });
        bootstrap.Collapse.getOrCreateInstance(course, { toggle: false }).show();
      }
    }
  }

  tabs.forEach(function (tab) {
    tab.addEventListener("shown.bs.tab", function () {
      var course = courseFromHash();
      if (!course || "#" + course.closest(".tab-pane").id !== tab.dataset.bsTarget) {
        history.replaceState(null, "", tab.dataset.bsTarget);
      }
    });
  });
  courses.forEach(function (course) {
    course.addEventListener("shown.bs.collapse", function () {
      if (course.closest(".tab-pane").classList.contains("active")) {
        history.replaceState(null, "", "#" + course.id.slice("course-".length));
      }
    });
  });
  window.addEventListener("hashchange", showFromHash);
  showFromHash();
});
