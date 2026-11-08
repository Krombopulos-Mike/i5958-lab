// TCP reachability probe from datagripe container
const net = require("node:net");
const targets = (process.argv[2] || "10.156.1.207:80,10.156.1.207:443,10.156.0.47:80,10.156.0.47:443,10.156.0.59:80,10.156.0.59:443,10.103.0.160:80,10.103.0.160:443,10.0.230.3:6443,10.0.230.4:5432").split(",");
function check(t) {
  return new Promise((res) => {
    const [h, p] = t.split(":");
    const s = new net.Socket(); let done = false;
    const fin = (r) => { if (!done) { done = true; try { s.destroy(); } catch (e) {} res(`${r} ${t}`); } };
    s.setTimeout(4000);
    s.on("connect", () => fin("OPEN"));
    s.on("timeout", () => fin("TIMEOUT"));
    s.on("error", (e) => fin("ERR:" + e.code));
    s.connect(parseInt(p), h);
  });
}
(async () => {
  console.log("host:", require("node:os").hostname());
  for (const t of targets) console.log(await check(t));
})();
