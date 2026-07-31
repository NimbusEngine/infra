# Monitoring

kube-prometheus-stack(helm)으로 Prometheus + Grafana 배포.

> ⚠️ **TODO** — 실제 helm values를 채우세요.
> VM에서: `helm get values prometheus -n monitoring > prometheus-values.yaml`

## 구성
- **Prometheus** — 노드/파드/컨테이너 메트릭 수집 (pull/scrape 방식)
- **Grafana** — 대시보드 시각화. 외부 노출 Ingress는 [../manifests/grafana-ingress.yaml](../manifests/grafana-ingress.yaml) 참고
  (helm 기본값이 Ingress를 생성하지 않아 직접 추가 — [트러블슈팅](../docs/troubleshooting.md#1-grafana-접속-불가-404-not-found))

## 채워야 할 내용
- [ ] `prometheus-values.yaml` (helm values)
- [ ] Grafana admin 비밀번호 관리 방식 (Secret)
- [ ] 커스텀 대시보드 JSON (있으면)
