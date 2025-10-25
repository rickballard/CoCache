self.addEventListener("install", e => {
  e.waitUntil(caches.open("opename-v1").then(c => c.addAll([
    "/", "/assets/style.css",
    "/assets/opename-192.png","/assets/opename-512.png",
    "/docs/","/docs/scripttagger/","/docs/scripttagger/demo.html","/downloads/scripttagger.html"
  ])));
});
self.addEventListener("fetch", e => {
  e.respondWith(
    caches.match(e.request).then(r => r || fetch(e.request).then(resp => {
      const copy = resp.clone();
      caches.open("opename-v1").then(c => c.put(e.request, copy)).catch(()=>{});
      return resp;
    }).catch(()=>caches.match("/")))
  );
});