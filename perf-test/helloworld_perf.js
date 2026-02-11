import http from "k6/http";
import { check, sleep } from "k6";
import { Trend, Rate } from "k6/metrics";

const TTFB = new Trend("ttfb_ms");
const ERR = new Rate("errors");

const BASE_URL = __ENV.BASE_URL || "http://34.xxx.xxx.xxx/"; // e.g., http://<LB_IP>/ or https://<domain>/
const HOST = __ENV.HOST || ""; // e.g., helloworld.example.com (needed if you hit the IP directly)
const PATH = __ENV.PATH || "/";

export const options = {
  scenarios: {
    ramping_load: {
      executor: "ramping-vus",
      startVUs: 0,
      stages: [
        { duration: "30s", target: 10 },
        { duration: "1m", target: 50 },
        { duration: "2m", target: 200 },
        { duration: "30s", target: 0 },
      ],
      gracefulRampDown: "30s",
    },
  },
  thresholds: {
    // Tune these after your first run
    http_req_failed: ["rate<0.01"],         // <1% requests fail
    http_req_duration: ["p(95)<500"],       // p95 latency < 500ms
    errors: ["rate<0.01"],
  },
};

export default function () {
  const url = `${BASE_URL.replace(/\/$/, "")}${PATH}`;

  const params = {
    timeout: "10s",
    headers: HOST ? { Host: HOST } : {},
  };

  const res = http.get(url, params);

  // Time to first byte is a good proxy for backend responsiveness
  TTFB.add(res.timings.waiting);

  const ok = check(res, {
    "status is 200": (r) => r.status === 200,
    "ttfb < 300ms": (r) => r.timings.waiting < 300,
    "total < 800ms": (r) => r.timings.duration < 800,
  });

  if (!ok) ERR.add(1);

  // Small think time to simulate real users; set to 0 for pure throughput
  sleep(0.1);
}
