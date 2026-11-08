#!/bin/sh
echo "== id =="; id; hostname; ip addr 2>/dev/null | grep -E 'inet ' | head -8
echo "== tools =="; for c in bash sh openssl perl curl wget python3 nc; do command -v $c || echo "$c=NO"; done
echo "== tcp =="
for t in 10.156.1.207:80 10.156.1.207:443 10.156.0.47:80 10.156.0.47:443 10.156.0.59:80 10.156.0.59:443 10.103.0.160:80 10.103.0.160:443 10.156.1.7:443 10.0.230.4:5432 10.156.1.207:22; do
  ip=${t%:*}; p=${t#*:}
  if timeout 4 bash -c "exec 3<>/dev/tcp/$ip/$p" 2>/dev/null; then echo "OPEN $t"; else echo "CLOSED $t"; fi
done
echo "== dns =="
getent hosts awd-backoffice.delasport.com traefik-gw.int.delasport.com member.int.delasport.com payment-monitor.bo.prod.delasport.com 2>&1 | head -10
echo "== done =="
