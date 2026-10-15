document.addEventListener("DOMContentLoaded", function () {
  var tabs = document.querySelectorAll('#area-tabs [data-bs-toggle="pill"]');
  var courses = document.querySelectorAll(".course-list .accordion-collapse");
  var catalogueTitle = document.title;

  function updateTitle() {
    var selected = document.querySelector(".tab-pane.active .accordion-collapse.show");
    document.title = selected ? selected.dataset.courseTitle : catalogueTitle;
  }

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
      updateTitle();
    });
  });
  courses.forEach(function (course) {
    var share = course.querySelector("[data-share-course]");
    var status = course.querySelector("[data-share-status]");
    var shareUrl = course.querySelector("[data-share-url]");
    share.addEventListener("click", async function (event) {
      event.preventDefault();
      status.textContent = "";
      shareUrl.hidden = true;
      if (navigator.clipboard && navigator.clipboard.writeText) {
        try {
          await navigator.clipboard.writeText(share.href);
          status.textContent = "Course link copied!";
          return;
        } catch (error) {
          status.textContent = "Could not copy the link automatically. Copy the selected link below.";
        }
      } else {
        status.textContent = "Clipboard unavailable. Copy the selected link below.";
      }
      shareUrl.value = share.href;
      shareUrl.hidden = false;
      shareUrl.focus();
      shareUrl.select();
    });
    course.addEventListener("shown.bs.collapse", function () {
      if (course.closest(".tab-pane").classList.contains("active")) {
        history.replaceState(null, "", "#" + course.id.slice("course-".length));
      }
      updateTitle();
    });
    course.addEventListener("hidden.bs.collapse", updateTitle);
  });
  window.addEventListener("hashchange", showFromHash);
  showFromHash();
});
