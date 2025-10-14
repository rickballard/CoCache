(function(){
  function sparkle(container,count){
    for(var i=0;i<count;i++){
      var s=document.createElement("div");
      var size=Math.random()*2+1;
      s.style.position="absolute"; s.style.width=size+"px"; s.style.height=size+"px";
      s.style.borderRadius="50%"; s.style.background="#cde7ff";
      s.style.left=(Math.random()*100)+"%"; s.style.top=(Math.random()*100)+"%";
      s.style.opacity="0"; s.style.boxShadow="0 0 8px #9fd6ff";
      s.style.animation="sp "+(2+Math.random()*2)+"s linear "+(Math.random()*1.2)+"s infinite";
      container.appendChild(s);
    }
    var st=document.createElement("style");
    st.textContent="@keyframes sp{0%{opacity:0}10%{opacity:.9}90%{opacity:.9}100%{opacity:0}}";
    container.appendChild(st);
  }
  function phrases(container){
    ["You Will Always Matter","You Own CoCivium","CoEvolve Our Future","No Corruption, No Coercion, No Crowns"]
      .forEach(function(t,i){ var p=document.createElement("div"); p.className="co-ccv-phrase";
        p.style.animationDelay=(0.4 + i*0.9)+"s"; p.textContent=t; container.appendChild(p); });
  }
  function showOverlay(url){
    var ov=document.createElement("div"); ov.className="co-ccv-overlay show";
    var stars=document.createElement("div"); stars.className="co-ccv-stars";
    ov.appendChild(stars); document.body.appendChild(ov);
    sparkle(stars,220); phrases(ov);
    setTimeout(function(){ window.open(url,"_blank","noopener"); }, 2600);
    setTimeout(function(){ ov.remove(); }, 3200);
  }
  document.addEventListener("click", function(e){
    var a = e.target.closest && e.target.closest('a[href]'); if(!a) return;
    var href = a.getAttribute('href') || "";
    if(/^https?:\/\/(www\.)?cocivium\.org\/?$/i.test(href)){ e.preventDefault(); showOverlay(href); }
  }, true);
})();