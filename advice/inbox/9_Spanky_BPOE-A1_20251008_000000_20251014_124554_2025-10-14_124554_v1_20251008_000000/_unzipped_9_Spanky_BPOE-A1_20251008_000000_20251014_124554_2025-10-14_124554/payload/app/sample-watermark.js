(function(){
  try{
    var qp=new URLSearchParams(location.search),
        q =qp.get("sample"),
        wm=qp.get("wm"),
        printOn=(qp.get("printwm")==="1");
    function on(t){ document.body.classList.add("is-sample"); if(t){ document.body.setAttribute("data-watermark", t); } }
    function off(){ document.body.classList.remove("is-sample"); document.body.removeAttribute("data-watermark"); document.body.removeAttribute("data-print"); }
    if(q==="0"){ off(); } else if(q==="1" || (document.body && document.body.getAttribute("data-sample")==="1")){ on(wm); }
    if(printOn){ document.body.setAttribute("data-print","1"); }
    document.addEventListener("keydown", function(e){
      if(e.altKey && (e.key==="s"||e.key==="S")){ if(document.body.classList.contains("is-sample")) off(); else on(wm||"SAMPLE"); }
    });
  }catch(e){}
})();