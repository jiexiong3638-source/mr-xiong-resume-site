const sections = [...document.querySelectorAll("main section[id]")];
const navLinks = [...document.querySelectorAll(".top-nav a")];

const navObserver = new IntersectionObserver(
  (entries) => {
    const visible = entries
      .filter((entry) => entry.isIntersecting)
      .sort((a, b) => b.intersectionRatio - a.intersectionRatio)[0];
    if (!visible) return;
    navLinks.forEach((link) => {
      link.classList.toggle("active", link.getAttribute("href") === `#${visible.target.id}`);
    });
  },
  { threshold: [0.35, 0.6] },
);

sections.forEach((section) => navObserver.observe(section));

const revealTargets = document.querySelectorAll(
  ".fit-grid article, .timeline-item, .project-card, .outcome-grid div",
);

const revealObserver = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("visible");
        revealObserver.unobserve(entry.target);
      }
    });
  },
  { threshold: 0.12 },
);

revealTargets.forEach((target) => {
  target.classList.add("reveal");
  revealObserver.observe(target);
});

const copyButton = document.querySelector("[data-copy-link]");

copyButton?.addEventListener("click", async () => {
  const url = window.location.href;
  try {
    await navigator.clipboard.writeText(url);
    copyButton.textContent = "已复制";
  } catch {
    copyButton.textContent = "复制失败";
  }
  window.setTimeout(() => {
    copyButton.textContent = "复制网站链接";
  }, 1800);
});
