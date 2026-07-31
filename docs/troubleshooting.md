# Troubleshooting

## 1. Grafana 접속 불가 (404 Not Found)

### Issue
- Prometheus + Grafana 모니터링 스택을 helm으로 배포한 뒤 브라우저로 Grafana 접속 시도
- `grafana.158.247.251.109.sslip.io:26117` 접속 시 **404 Not Found**, 응답 본문에 `nginx` 표시
- Grafana 앱은 정상 기동된 상태인데도 외부 접근 자체가 불가능

### 원인
- 404 본문이 `nginx`인 것으로 보아, 요청은 ingress-nginx까지 도달했으나 **해당 호스트를 라우팅할 규칙이 없어** ingress-nginx가 기본 404(default backend)를 반환한 것
- 계층별로 소거하며 확인:
  - `kubectl get pods -n monitoring | grep grafana` → **Running (3/3)**, 앱 정상
  - `kubectl get svc -n monitoring | grep grafana` → `prometheus-grafana` **Service 존재**, 내부 경로 정상
  - `kubectl get ingress -A` → **grafana Ingress 없음** (원인 확정)
- helm으로 kube-prometheus-stack 설치 시 Grafana의 **Ingress 리소스를 기본 생성하지 않음** — Service까지만 존재하고 외부 노출 경로(Ingress)가 누락되어, ingress-nginx가 `grafana.*` 호스트를 어디로 보낼지 알 수 없는 상태였음

### 해결
- monitoring 네임스페이스에 Grafana용 Ingress를 직접 작성해 `prometheus-grafana` Service로 라우팅 연결
  ```bash
  kubectl apply -f manifests/grafana-ingress.yaml
  kubectl get ingress -A          # grafana 규칙 생성 확인
  ```
- 이후 `grafana.158.247.251.109.sslip.io:26117` 정상 접속 확인

### 함정 포인트 / 배운 점
- **404 본문의 출처(`nginx` vs 앱 화면)가 핵심 단서.** Grafana가 죽었다면 연결 자체가 안 되거나 Grafana 에러 화면이 떠야 하는데, nginx가 404를 냈다는 건 "요청은 도착했으나 규칙이 없다"는 뜻
- 이 구분으로 문제를 **"앱"이 아니라 "라우팅 계층(Ingress)"으로** 빠르게 좁힐 수 있었음
- K8s의 **Pod → Service → Ingress** 노출 계층 구조를 이해하고 있어야 가능한 진단

---

<!-- 템플릿: 아래 형식으로 다른 트러블슈팅도 추가하세요
## 2. <제목>

### Issue
- 증상 (에러 메시지 그대로)

### 원인
- 왜 발생했는지 (계층별 확인 과정 포함)

### 해결
- 실제 실행한 명령/변경

### 함정 포인트 / 배운 점
- 남들은 놓치기 쉬운 디테일
-->
