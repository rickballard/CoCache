export default {
  async fetch(req, env) {
    if (req.method === "OPTIONS") return handleOptions(req);
    const origin = req.headers.get("origin") || "";
    const allowed=["https://copolitic.org","https://www.copolitic.org","https://rickballard.github.io"];
    if(!allowed.some(o=>origin.startswith?origin.startswith(o):origin.startswith(o))) return new Response("forbidden",{status:403});
    const ip = req.headers.get("CF-Connecting-IP");
    const payload={company:null,domain:null,ip:null,source:"none"};
    if(ip){
      payload.ip=ip;
      if(env.IPINFO_TOKEN){
        try{
          const r=await fetch(`https://ipinfo.io/${ip}/json?token=${env.IPINFO_TOKEN}`);
          if(r.ok){
            const d=await r.json();
            const company=(d.company&&d.company.name)||((d.org||"").replace(/^AS\d+\s+/,"")||null);
            const domain=(d.company&&d.company.domain)||null;
            if(company) Object.assign(payload,{company,domain,source:"ipinfo"});
          }
        }catch{}
      }
    }
    return new Response(JSON.stringify(payload),{headers:corsHeaders(origin)});
  }
}
function corsHeaders(origin){return {"content-type":"application/json; charset=utf-8","access-control-allow-origin":origin,"vary":"origin","access-control-allow-methods":"GET,OPTIONS","access-control-allow-headers":"content-type"}}
function handleOptions(req){const origin=req.headers.get("origin")||"";return new Response(null,{status:204,headers:corsHeaders(origin)})}
