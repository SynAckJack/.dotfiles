#!/usr/bin/env bash
#~/pihole_stats

#very shitty way to get pihole stats. But hey, it works.

set -euo pipefail

if [ "$(curl -s "http://pi.hole/admin/api.php")" ] ; then
	
	echo "[✅] - Pi-hole reachable"
	echo "[✅] - Retrieving stats"

	domains_blocked="$(curl -s "http://pi.hole/admin/api.php" | jq -r .domains_being_blocked )"

	dns_queries_today="$(curl -s "http://pi.hole/admin/api.php" | jq -r .dns_queries_today )"

	ads_blocked_today="$(curl -s "http://pi.hole/admin/api.php" | jq -r .ads_blocked_today )"

	ads_percentage_today="$(curl -s "http://pi.hole/admin/api.php" | jq -r .ads_percentage_today )"

	uptime_days="$(curl -s "http://pi.hole/admin/api.php" | jq -r .gravity_last_updated.relative.days )"

	uptime_hours="$(curl -s "http://pi.hole/admin/api.php" | jq -r .gravity_last_updated.relative.hours )"

	uptime_minutes="$(curl -s "http://pi.hole/admin/api.php" | jq -r .gravity_last_updated.relative.minutes )"

cat << EOF
[🎉] Pi-hole Stats 🤙
	Domains Blocked			${domains_blocked}
	DNS Queries Today		${dns_queries_today}
	Ads Blocked Today		${ads_blocked_today}
	Ads Blocked Today (%)		${ads_percentage_today}%
	Uptime 				${uptime_days}:${uptime_hours}:${uptime_minutes}
EOF

else 
	echo "[❌] Couldn't connect to pi-hole"
	exit 0
fi
