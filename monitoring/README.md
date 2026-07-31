# Monitoring

`kube-prometheus-stack`(helm)으로 Prometheus + Grafana를 배포한다.

## 설치 정보

| 항목 | 값 |
|---|---|
| Helm chart | kube-prometheus-stack 87.10.1 |
| Release | `prometheus` |
| Namespace | `monitoring` |
| Prometheus Operator | v0.92.1 |

## 구성

- **Prometheus** — 노드/파드/컨테이너 메트릭을 pull(scrape) 방식으로 수집한다.
- **Grafana** — 대시보드 시각화. 외부 노출 Ingress는 helm 기본값에 포함되지 않아 별도로 추가했다. → [../manifests/grafana-ingress.yaml](../manifests/grafana-ingress.yaml)
  - 접속: `http://grafana.158.247.251.109.sslip.io:26117`

## Grafana admin 비밀번호

```bash
kubectl get secret -n monitoring prometheus-grafana \
  -o jsonpath="{.data.admin-password}" | base64 -d
```
