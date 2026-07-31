# Monitoring

`kube-prometheus-stack`(helm)으로 Prometheus + Grafana 배포.

## 설치 정보

| 항목 | 값 |
|---|---|
| Helm chart | kube-prometheus-stack 87.10.1 |
| Release 이름 | `prometheus` |
| Namespace | `monitoring` |
| Prometheus Operator | v0.92.1 |

## 구성
- **Prometheus** — 노드/파드/컨테이너 메트릭을 pull(scrape) 방식으로 수집
- **Grafana** — 대시보드 시각화. 외부 노출 Ingress는 별도로 직접 추가
  ([../manifests/grafana-ingress.yaml](../manifests/grafana-ingress.yaml))
  - helm 기본값이 Grafana Ingress를 생성하지 않아 발생한 404 이슈 → [트러블슈팅 #1](../docs/troubleshooting.md#1-grafana-접속-불가-404-not-found)
  - 접속: `http://grafana.158.247.251.109.sslip.io:26117`

## Grafana admin 비밀번호 확인
```bash
kubectl get secret -n monitoring prometheus-grafana \
  -o jsonpath="{.data.admin-password}" | base64 -d
```

## TODO
- [ ] helm values 첨부: `helm get values prometheus -n monitoring > prometheus-values.yaml`
- [ ] 커스텀 대시보드 JSON (있으면)
